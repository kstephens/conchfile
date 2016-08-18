require 'conchfile/format'
require 'conchfile/format/mime_types'
require 'conchfile/deep'

module Conchfile
  class Format
    class Auto < self
      attr_accessor :default, :mime_types

      def call content, env
        meta_data = content.meta_data
        format, mt = mime_types.format_for_meta_data(meta_data)
        logger.info { "Determined Format #{format} #{mt} for #{meta_data.inspect}" } if format

        format ||= @default
        raise Error, "Cannot determine Format for #{meta_data.inspect}" unless format

        content.meta_data.mime_type = mt if mt

        ap(class: self.class,
           format: format.class,
           content: [ content.class, content.meta_data ]) if @debug

        format = format.new if format.respond_to?(:new)
        data = format.call(content, env)

        meta_data = meta_data.dup
        meta_data.mime_type = mime_types.mime_type(mt) if mt
        Deep.deep_meta_data!(data, meta_data)

        ap(class: self.class,
           format: format.class,
           data: [ data.class, data.meta_data ]) if @debug

        data
      end

      def mime_types
        @mime_types || Format::MimeTypes.instance
      end

      def inspect_ivars
        [ :default ]
      end
    end
  end
end

