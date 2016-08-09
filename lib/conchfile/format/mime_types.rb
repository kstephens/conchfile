require 'conchfile/format'
require 'conchfile/initialize'
require 'mime-types'

module Conchfile
  class Format
    class MimeTypes
      include Initialize
      attr_accessor :formats

      def self.instance
        @@instance ||= new
      end
      def self.instance= x
        @@instance = x
      end
      @@instance = nil

      def initialize * args
        @formats = { }
      end

      def register cls, type, *types
        type = type.to_s.dup.freeze
        ([ type ] + types).each do | t |
          t = t.to_s.dup.freeze
          @formats[t] = [ cls, type ].freeze
        end
      end

      def self.register *args
        instance.register(*args)
      end

      def format type
        @formats[type.to_s]
      end

      def format_for_meta_data meta_data
        mime_type  = meta_data.mime_type
        uri        = meta_data.uri_alt || meta_data.uri
        suffix     = uri && uri.suffix

        attempts = [
          # Try explicit non-text/plain mime-type.
          mime_type && mime_type.to_s != TEXT_PLAIN && mime_type,
          # Try alt or uri suffix:
          # Try explict registered format.
          suffix && "x-suffix/#{suffix}",
          # Infer from suffix.
          suffix && mime_type_for_suffix(suffix),
          # Try explict mime-type.
          mime_type,
          # Default to text/plain.
          TEXT_PLAIN,
        ]

        attempts.
          compact.
          map{|mt| format(mt)}.
          compact.
          first
      end

      def mime_type x
        case x
        when MIME::Type
          x
        when String
          MIME::Types[x].first # why first?
        else
          nil
        end
      end

      def mime_type_for_suffix suffix
        MIME::Types.find{|mt| mt.extensions.include?(suffix)}
      end

      TEXT_PLAIN = 'text/plain'.freeze
    end
  end
end
