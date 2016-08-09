require 'conchfile/initialize'
require 'conchfile/inspect'
require 'conchfile/logger'

module Conchfile
  class Format
    class Error < Conchfile::Error; end
    include Initialize, Inspect, Logger
    attr_accessor :format

    def call data, env = nil
      data
    end

    def format
      @format || Symbolize.new(format: Auto.new)
    end

    def inspect_ivars
      [ :format ]
    end
  end
end

