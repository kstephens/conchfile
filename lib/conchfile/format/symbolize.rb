require 'conchfile/format'
require 'conchfile/deep'

module Conchfile
  class Format
    class Symbolize < self
      attr_accessor :symbolize

      def call content, env
        data = format.call(content, env)
        Deep.deep_symbolize!(data) if symbolize != false
        data
      end
    end
  end
end

