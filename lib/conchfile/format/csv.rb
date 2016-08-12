require 'conchfile/format'
require 'csv'

module Conchfile
  class Format
    class CSV < self
      attr_accessor :prefix
      MimeTypes.register(self, 'x-suffix/csv')

      def call content, env
        rows = [ ]
        CSV.foreach(StringIO.new(content), # ??? parse from string?
                    header_converters: :symbol,
                    converters: :numeric
                    ) do |row|
          rows << row
        end
        result = { }
        result[prefix] = rows
        result
      end

    end
  end
end

