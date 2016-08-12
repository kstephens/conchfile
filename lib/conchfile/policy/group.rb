require 'conchfile/policy'

module Conchfile
  class Policy
    class Group < self
      attr_accessor :policies

      def initialize *args
        super
        @policies ||= [ ]
      end

      def valid_policy?
        policies.all?(&:valid_policy?)
      end

      def invalidated_policy!
        super
        policies.each(&:invalidated_policy!)
      end

      def _execute_policy!
        policies.each(&:execute_policy!)
      end

      def inspect_ivars
        [ :name, :policies ]
      end
    end
  end
end
