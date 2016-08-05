require 'conchfile/source'

module Conchfile
  class Source
    class Static < self
      attr_accessor :static
      def call env
        @static
      end
    end
  end
end

