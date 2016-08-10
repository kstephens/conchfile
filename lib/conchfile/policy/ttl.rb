require 'conchfile/policy'

module Conchfile
  class Policy
    class Ttl < self
      attr_accessor :now, :ttl, :atime, :expires

      def valid_policy?
        now = self.now
        atime && expires && now < expires
      end

      def with_policy
        result = yield
        now = self.now
        self.atime = now
        self.expires = now + ttl
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
