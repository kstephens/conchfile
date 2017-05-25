$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'conchfile'
require 'awesome_print'
require 'pry-debugger'

require 'stringio'

module Conchfile::SpecHelper
  extend self
  def logger
    @logger ||= new_logger
  end
  def new_logger str = logger_output
    Conchfile::Logger.logger = \
    ::Logger.new(StringIO.new(str))
  end
  def logger_output
    @logger_string ||= ''.dup
  end
  self.new_logger(''.dup)
end

RSpec.configure do |config|
  config.include Conchfile::SpecHelper
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
