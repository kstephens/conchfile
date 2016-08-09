require 'conchfile/format'
require 'yaml'

module Conchfile
  class Format
    class Yaml < self
      MimeTypes.register(self,
                         'text/x-yaml', 'x-suffix/yaml', 'x-suffix/yml')

      def call content, env
        ::YAML.load(content)
      end
    end
  end
end

