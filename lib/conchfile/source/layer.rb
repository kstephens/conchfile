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

      def _load! env
        layers.each {|s| s.load!(env) }
      end

      def _unload! opts
        layers.each{|s| s.unload!(opts)} if opts[:deep]
      end

      def inspect_ivars
        [ :name , :layers ]
      end
    end
  end
end

