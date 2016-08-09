require 'conchfile/format'
require 'multi_json'

module Conchfile
  class Format
    class Json < self
      MimeTypes.register(self, 'application/json', 'x-suffix/json')

      def call content, env
        content = content.gsub(%{^\s*//[^\n]*}, '') # ADHOC // comments.
        ::MultiJson.load(content)
      end

      def inverse
        lambda do | data, env |
          ::MultiJson.dump(data, pretty: true)
        end
      end
    end
  end
end

