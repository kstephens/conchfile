require 'conchfile/format'
require 'json'

module Conchfile
  class Format
    class Json < self
      Auto.register_for_mime_type(self, 'application/json', 'x-suffix/json')

      def call content, env
        content = content.gsub(%{^\s*//[^\n]*}, '')
        data = ::JSON.parse(content)
        Deep.deep_symbolize!(data) if symbolize != false
        data
      end
    end
  end
end

