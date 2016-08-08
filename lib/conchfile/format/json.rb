require 'conchfile/format'
require 'json'

module Conchfile
  class Format
    class Json < self
      Auto.register_for_mime_type(self, 'application/json', 'x-suffix/json')

      def call content, env
        content = content.gsub(%{^\s*//[^\n]*}, '') # ADHOC // comments.
        ::JSON.parse(content)
      end
    end
  end
end

