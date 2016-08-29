require 'conchfile/root'

module Conchfile
  class Policy < Root
    class Error < Conchfile::Error; end

    def check_policy!
      unless valid_policy?
        logger.info { "#{self.class} : Policy #{self.inspect} invalidated" }
        invalidated_policy!
      end
      self
    end

    def valid_policy?
      true
    end

    def invalidated_policy!
      should_unload!
      source.should_unload!
      self
    end

    def execute_policy!
      if should_unload?
        _execute_policy!
      end
      self
    end

    def _execute_policy!
      unload!(deep: true)
      load!
    end

    def _load! env
      source.load! env
      super
    end

    def _unload! opts
      source.unload! opts
      super
    end

    def with_policy
      yield
    end

    def _load! env
      with_policy do
        logger.info { "#{self.class} : Policy #{self.inspect} _load!" }
        super
      end
    end
  end
end
