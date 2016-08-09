require 'conchfile/format'
require 'multi_json'

module Conchfile
  class Format
    class Json < self
      MimeTypes.register(self, 'application/json', 'x-suffix/json')

      def call content, env
        content = content.gsub(%{^\s*//[^\n]*}, '') # ADHOC // comments.
        ::JSON.parse(content)
      end
    end
  end
end

