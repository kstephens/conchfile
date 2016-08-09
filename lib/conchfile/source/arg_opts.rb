require 'conchfile/lazy_load'
require 'conchfile/source'

module Conchfile
  class Source
    class ArgOpts < self
      attr_accessor :argv

      def call root
        now = Time.now
        meta_data = MetaData.new(source: self, atime: now)

        result = { }
        opts = { }
        argv = self.argv.map(&:dup)
        args = argv.map(&:dup)
        until args.empty?
          case arg = args.shift
          when /^--([\w\.]+)$/
            k = $1; v = shift
          when /^--([\w\.]+)=(.*)$/
            k = $1; v = $2
          else
            args.unshift arg
            break
          end

          opts[k] = v

          ks = k.split('.')
          lk = ks.pop
          h = result
          ks.each do | k |
            h = h[k.to_sym] = { }
          end

          h[lk.to_sym] = v
        end

        @opts = opts
        result[:opts] = opts
        result[:argv] = argv
        result[:args] = args
        # binding.pry
        Deep.deep_meta_data!(result, meta_data)
        result
      end

      def inspect_ivars
        [ :opts ]
      end
    end
  end
end

