require 'thread'

module Conchfile
  module LoadState
    attr_accessor :load_state, :should_unload

    def initialize_load
      @load_state_mutex = Mutex.new
    end

    def load! *args
      @load_state_mutex.synchronize do
        logger.debug { "#{self.class} load! #{@load_state.inspect}" }
        case @load_state
        when :loading, :loaded
        when :invalid, :unloaded, :failed, nil
          @load_state = :loading
          begin
            if block_given?
              yield *args
            else
              send(:_load!, *args)
            end
            @load_state = :loaded
            @should_unload = false
          rescue
            @load_state = :failed
            raise
          end
        else
          exc = Error.new("invalid load_state: #{@load_state.inspect}")
          logger.error exc
          raise exc
        end
      end unless @load_state == :loaded ||  @load_state == :loading
      self
    end

    def loaded?
      @load_state == :loading or @load_state == :loaded
    end

    def should_unload!
      @load_state_mutex.synchronize do
        case @load_state
        when :loading
        when :loaded
          _should_unload! if respond_to?(:_should_unload!)
          @should_unload = true
        end
      end
    end
    alias :should_unload? :should_unload

    def unload!
      @load_state_mutex.synchronize do
        logger.debug { "#{self.class} unload! #{@load_state.inspect}" }
        case @load_state
        when :loaded
          if block_given?
            yield
          else
            _unload!
          end
          @load_state = :unloaded
        end
      end unless @load_state == :unloaded
      self
    end

  end
end

