require File.expand_path('../test_helper', __FILE__)

class StatsdTest < Test::Unit::TestCase
  
  def setup
    Statsd.host = 'localhost'
    Statsd.port = 8125
    super
  end
  
  context "timing" do
    
    should "send with ms" do
      expected_send('test.stat:23|ms')
      Statsd.timing('test.stat', 23)
    end
    
    should "log when sampled" do
      fake_rand(0.09)
      expected_send('test.stat:23|ms@0.1')
      Statsd.timing('test.stat', 23, 0.1)
    end
    
    should "not log when not sampled" do
      fake_rand(0.11)
      expect_nothing
      Statsd.timing('test.stat', 23, 0.1)      
    end

    should "work with a block" do
      expected_send(/^test.stat:2[234]\|ms$/)
      Statsd.timing('test.stat') do
        sleep 0.023
      end
    end
    
  end
  
  context "increment" do
    
    should "send number" do
      expected_send('test.stat:1|c')
      Statsd.increment('test.stat')
    end

    should "log when sampled" do
      fake_rand(0.09)
      expected_send('test.stat:1|c@0.1')
      Statsd.increment('test.stat', 0.1)
    end

    should "not log when not sampled" do
      fake_rand(0.11)
      expect_nothing
      Statsd.increment('test.stat', 0.1)      
    end
        
  end
  
  context "decrement" do
    
    should "send number" do
      expected_send('test.stat:-1|c')
      Statsd.decrement('test.stat')
    end

    should "log when sampled" do
      fake_rand(0.09)
      expected_send('test.stat:-1|c@0.1')
      Statsd.decrement('test.stat', 0.1)
    end

    should "not log when not sampled" do
      fake_rand(0.11)
      expect_nothing
      Statsd.decrement('test.stat', 0.1)      
    end
    
  end
  
  context "host" do
    
    should "be gettable and settable" do
      Statsd.host = 'statsd-01'
      assert_equal 'statsd-01', Statsd.host
    end
    
  end
  
  context "port" do

    should "be gettable and settable" do
      Statsd.port = 1234
      assert_equal 1234, Statsd.port
    end
    
  end
  
  context "host_ip_addr" do
    
    should "resolve dns" do
      Statsd.host = 'localhost'
      assert loopback?(Statsd.host_ip_addr)
    end
    
    should "be cleared when host is set" do
      Statsd.host = 'statsd-01'
      assert_nil Statsd.instance_variable_get(:@host_ip_addr)
    end
    
  end
  
  private
  
  def fake_rand(v)
    Statsd.stubs(:rand).returns(v)
  end
  
  def expected_send(buf)
    case buf
    when Regexp
      buf_re = buf
    else
      buf_re = Regexp.new(buf)
    end
    UDPSocket.any_instance.expects(:send).with(regexp_matches(buf_re), 0, Statsd.host_ip_addr, Statsd.port).once
  end
  
  def expect_nothing
    UDPSocket.any_instance.expects(:send).never
  end
  
  def loopback?(ip)
    ['::1', '127.0.0.1'].include?(ip)
  end
  
end
