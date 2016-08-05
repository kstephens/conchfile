require 'conchfile/format'
require 'yaml'

module Conchfile
  class Format
    class Yaml < self
      Auto.register_for_mime_type(self,
                                  'text/x-yaml', 'x-suffix/yaml', 'x-suffix/yml')

      def call content, env
        data = ::YAML.load(content)
        Deep.deep_symbolize!(data) if symbolize != false
        data
      end
    end
  end
end

