require 'conchfile/source'

module Conchfile
  class Source
    class Writer < self
      attr_accessor :source, :mime_types

      def initialize *args
        super
      end

      def call env
        data = source.call(env)
        return nil if data.nil?

        uri = transport.uri_(env)
        meta_data = MetaData.new(uri: uri, mime_type: transport.mime_type)

        format, mime_type = mime_types.format_for_meta_data(meta_data)
        format = format.new if format.respond_to?(:new)

        content = format.inverse.call(data, env)
        WithMetaData[content].meta_data.mime_type ||= mime_type

        logger.info { "#{self.class} : PUT #{uri} : #{mime_type} #{content.size} bytes" }
        transport.put(content, env)
        data
      end

      def << x
        source << x
        self
      end

      def mime_types
        @mime_types || Format::MimeTypes.instance
      end

      def inspect_ivars
        [ :name , :source, :transport ]
      end
    end
  end
end

