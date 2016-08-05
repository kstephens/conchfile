require 'conchfile/source'
require 'conchfile/deep'

module Conchfile
  class Source
    class Layer < self
      attr_accessor :layers

      def initialize *args
        super
        @layers ||= [ ]
      end

      def << layer
        @data = nil
        @layers << layer
        self
      end

      def call env
        result = { }

        layers.each do | layer |
          data = layer.call(env)
          next unless data
          result  = Deep.deep_merge(result, data)
        end

        src = self
        f = lambda do | x |
          case x
          when Module, Symbol
          else
            begin
              WithMetaData[x].meta_data.source ||= src
            rescue
            end
          end
          x
        end
        Deep.deep_visit!(result, f)
        result
      end

      def inspect_inner
        layers.inspect
      end
    end
  end
end

