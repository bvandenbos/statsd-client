# -*- encoding: utf-8 -*-
require File.expand_path("../lib/statsd", __FILE__)

Gem::Specification.new do |s|
  s.name        = "statsd-client"
  s.version     = Statsd::Version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ben VandenBos']
  s.email       = ['bvandenbos@gmail.com']
  s.homepage    = "http://github.com/bvandenbos/statsd-client"
  s.summary     = "Ruby client for statsd."
  s.description = "Ruby client for statsd."
  
  s.required_rubygems_version = ">= 1.3.6"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end

