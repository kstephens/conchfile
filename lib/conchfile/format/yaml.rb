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

      def inverse
        lambda do | data, env |
          data = WithMetaData.without(data)
          binding.pry
          ::YAML.dump(data)
        end
      end
    end
  end
end

