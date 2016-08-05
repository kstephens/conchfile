require 'conchfile/error'

module Conchfile
  class Dotty
    class Error < Conchfile::Error; end

    def self.[] x
      case x
      when Hash, Enumerable
        new(x)
      else
        x
      end
    end

    def initialize x
      @x = x
      freeze
    end

    def [] k
      Dotty[@x[k]]
    end

    def method_missing sel, *args, &blk
      if @x.respond_to?(sel) or ! args.empty? or blk
        super
      else
        Dotty[@x[sel]]
      end
    end
  end
end

