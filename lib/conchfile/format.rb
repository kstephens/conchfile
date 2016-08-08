require 'conchfile/initialize'
require 'conchfile/logger'

module Conchfile
  class Format
    class Error < Conchfile::Error; end
    include Initialize, Logger
    attr_accessor :format

    def call data, env = nil
      data
    end

    def format
      @format || Symbolize.new(format: Auto.new)
    end

    def inspect
      "#<#{self.class} #{inspect_inner}>"
    end

    def inspect_inner
      @format && @format.inspect
    end
  end
end

