require 'conchfile/hash_like'

module Conchfile
  # A proxy around a HashLike object
  # exposing #[] access as proxy methods.
  # Enforces limited read-only access.
  class Dotty
    def self.[] x
      case x
      when HashLike, Enumerable
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

    def []= k, v
      raise Error, "immutable"
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

