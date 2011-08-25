require 'socket'
require 'resolv'

class Statsd
  
  Version = '0.0.5'
  
  class << self
    
    attr_accessor :host, :port
    
    def host_ip_addr
      @host_ip_addr ||= Resolv.getaddress(host)
    end
    
    def host=(h)
      @host_ip_addr = nil
      @host = h
    end
    
    # +stat+ to log timing for
    # +time+ is the time to log in ms
    def timing(stat, time = nil, sample_rate = 1)
      if block_given?
        start_time = Time.now.to_f
        yield
        time = ((Time.now.to_f - start_time) * 1000).floor
      end
      send_stats("#{stat}:#{time}|ms", sample_rate)
    end
    
    # +stats+ can be a string or an array of strings
    def increment(stats, sample_rate = 1)
      update_counter stats, 1, sample_rate
    end
    
    # +stats+ can be a string or an array of strings
    def decrement(stats, sample_rate = 1)
      update_counter stats, -1, sample_rate
    end
    
    # +stats+ can be a string or array of strings
    def update_counter(stats, delta = 1, sample_rate = 1)
      stats = Array(stats)
      send_stats(stats.map { |s| "#{s}:#{delta}|c" }, sample_rate)
    end
    
    private
    
    def send_stats(data, sample_rate = 1)
      data = Array(data)
      sampled_data = []
      
      # Apply sample rate if less than one
      if sample_rate < 1
        data.each do |d|
          if rand <= sample_rate
            sampled_data << "#{d}@#{sample_rate}"
          end
        end
        data = sampled_data
      end
      
      return if data.empty?
      
      raise "host and port must be set" unless host && port
      
      begin
        sock = UDPSocket.new
        data.each do |d|
          sock.send(d, 0, host_ip_addr, port)
        end
      rescue # silent but deadly
      ensure
        sock.close
      end
      true
    end
    
  end
  
end
