require 'conchfile/format'
require 'conchfile/deep'
require 'mime-types'

module Conchfile
  class Format
    class Auto < self
      def call content, env
        meta_data = content.meta_data
        format, mt = format_for_meta_data(meta_data)
        logger.debug { "Determined Format #{format} #{mt} for #{meta_data.inspect}" } if format

        format ||= @default
        raise Error, "Cannot determine Format for #{meta_data.inspect}" unless format

        ap(class: self.class,
           format: format.class,
           content: [ content.class, content.meta_data ]) if @debug
        content.meta_data.mime_type = mt

        format = format.new if format.respond_to?(:new)
        data = format.call(content, env)

        meta_data = meta_data.dup
        meta_data.mime_type = mime_type(mt) if mt
        Deep.deep_meta_data!(data, meta_data)

        ap(class: self.class,
           format: format.class,
           data: [ data.class, data.meta_data ]) if @debug

        data
      end

      @@mime_type_to_class ||= { }
      def self.register_for_mime_type cls, type, *types
        ([ type ] + types).each do | t |
          @@mime_type_to_class[t.dup.freeze] = [ cls, type ]
        end
      end

      def format_for_meta_data meta_data
        f_mt = mt = nil
        mime_type = meta_data.mime_type
        # Try explicit non-text/plain mime-type.
        unless f_mt
          if mime_type && mime_type.to_s != TEXT_PLAIN
            f_mt = format_for_mime_type(mt = mime_type)
          end
        end
        # Try alt or uri suffix.
        unless f_mt
          u = meta_data.uri_alt || meta_data.uri
          f_mt = format_for_mime_type(mt = "x-suffix/#{u.suffix}")
        end
        # Try explict mime-type or default to text/plain.
        unless f_mt
          f_mt = format_for_mime_type(mt = mime_type || TEXT_PLAIN)
        end
        f_mt
      end

      def format_for_mime_type type
        @@mime_type_to_class[type.to_s]
      end

      def mime_type x
        case x
        when MIME::Type
          x
        when String
          MIME::Types[x].first # ??
        else
          nil
        end
      end

      TEXT_PLAIN = 'text/plain'.freeze
    end
  end
end

