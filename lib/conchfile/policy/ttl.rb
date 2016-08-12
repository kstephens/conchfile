require 'conchfile/policy'

module Conchfile
  class Policy
    class Ttl < self
      attr_accessor :now, :ttl, :atime, :expires

      def valid_policy?
        t = now
        atime && expires && t < expires
      end

      def with_policy
        result = yield
        t = now
        self.atime = t
        self.expires = t + ttl
        result
      end

      def now
        @now ? @now.call : Time.now
      end

      def inspect_ivars
        [ :name, :load_state, :ttl ]
      end
    end
  end
end
