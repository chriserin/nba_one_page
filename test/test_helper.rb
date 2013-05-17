require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)

  require "minitest/autorun"
  require 'vcr'
  require 'mocha/setup'

  VCR.configure do |vcr_config|
    vcr_config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
    vcr_config.hook_into :webmock 
    WebMock.allow_net_connect!(:net_http_connect_on_start => true)
  end

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

  class MiniTest::Unit::TestCase
    def setup
      #pattern dispath
      self.methods.each do |m|
        self.send(m) if m.to_s =~ /^setup_/
      end
    end

    def teardown
      self.methods.each do |m|
        self.send(m) if m.to_s =~ /^teardown_/
      end
    end

    def setup_clean_database
      DatabaseCleaner.start # usually this is called in setup of a test
    end

    def teardown_clean_database
      DatabaseCleaner.clean # cleanup of the test
    end
  end

end

Spork.each_run do
end
