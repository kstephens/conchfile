module Conchfile
  module HashLike
    ::Hash.send(:include, self)

    module Proxy
      include HashLike

      def [] k
        _delegate_data[k]
      end

      def key? k
        _delegate_data.key?(k)
      end

      def keys
        _delegate_data.keys
      end

      def values
        _delegate_data.values
      end

      def each &blk
        _delegate_data.each &blk
      end

      def to_hash
        _delegate_data.to_hash
      end
    end
  end
end
