require 'thread'

module Conchfile
  module LazyLoad
    attr_accessor :load_state

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

