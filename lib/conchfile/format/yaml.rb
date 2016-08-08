require 'conchfile/format'
require 'yaml'

module Conchfile
  class Format
    class Yaml < self
      Auto.register_for_mime_type(self,
                                  'text/x-yaml', 'x-suffix/yaml', 'x-suffix/yml')

      def call content, env
        ::YAML.load(content)
      end
    end
  end
end

