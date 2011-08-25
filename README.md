statsd-client
=============

This is a simple client for [statsd](https://github.com/etsy/statsd).  It's
roughly equivalent to the php and python examples included in the statsd
repo.  I put it in a gem to make it easy to install, reuse, etc.

Example
-------

    require 'rubygems'
    require 'statsd'
    
    Statsd.host = 'localhost'
    Statsd.port = 8125
    
    Statsd.increment('some_counter') # basic incrementing
    Statsd.increment('system.nested_counter', 0.1) # incrementing with sampling (10%)

    Statsd.decrement(:some_other_counter) # basic decrememting using a symbol
    Statsd.decrement('system.nested_counter', 0.1) # decrementing with sampling (10%)
    
    Statsd.timing('some_job_time', 20) # reporting job that took 20ms
    Statsd.timing('some_job_time', 20, 0.05) # reporting job that took 20ms with sampling (5% sampling)
    
    # passing a block to `timing` will capture the time it takes to execute   
    Statsd.time('some_job_time') do
      # do some job
    end
    
