require 'conchfile/initialize'
require 'conchfile/logger'

module Conchfile
  class Format
    class Error < Conchfile::Error; end
    include Initialize, Logger
    attr_accessor :default, :symbolize

    def call data, env = nil
      data
    end

    def inspect
      "#<#{self.class} #{inspect_inner}>"
    end

    def inspect_inner
      @default && @default.inspect
    end
  end
end

