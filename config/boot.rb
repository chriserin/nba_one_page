require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

#class Object
#  def self.method_added(name)
#    p "method_added #{name} to #{self}"
#  end
#end
#
#module Kernel
#  def method_added(name)
#    p "method_added #{name} to #{self}"
#  end
#end
#
#module Enumerable
#  def self.method_added(name)
#    p "method_added #{name} to #{self}"
#  end
#end
