require 'conchfile/format'
require 'conchfile/meta_data'
require 'erb'

module Conchfile
  class Format
    class Erb < self
      Auto.register_for_mime_type(self, 'application-x/erb', 'x-suffix/erb')

      attr_accessor :erb

      def call content, env
        WithMetaData[content]
        if allow_erb? and is_erb?(content)
          content = expand_erb(content, env)
        end
        format.call(content, env)
      end

      def allow_erb?
        erb != false
      end

      def is_erb? content
        erb || erb_suffix?(content) || erb_header?(content)
      end

      def erb_suffix? content
        u = content.meta_data.uri # _alt || content.meta_data.uri
        u and u.suffix == 'erb'
      end

      def erb_header? content
        content =~ /-\*-\s+erb\s+-\*-/
      end

      def expand_erb content, env
        meta_data = content.meta_data

        erb = ERB.new(content, nil, '-')
        erb.filename = meta_data.uri.to_s
        # erb.lineno = 1

        result = erb.result(binding)

        # Remove .erb suffix to allow Auto to figure out mime-type from suffix.
        if erb_suffix?(content)
          meta_data = meta_data.dup
          meta_data.mime_type = nil
          meta_data.uri_alt = meta_data.uri.without_suffix
        end
        WithMetaData[result, meta_data]
        result
      end
    end
  end
end

