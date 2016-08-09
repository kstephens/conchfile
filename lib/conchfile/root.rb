require 'conchfile/initialize'
require 'conchfile/inspect'
require 'conchfile/lazy_load'
require 'conchfile/meta_data'
require 'conchfile/logger'
require 'conchfile/deep'
require 'thread'

module Conchfile
  class Root
    class Error < Conchfile::Error; end

    include HashLike, Initialize, Inspect, LazyLoad, WithMetaData, Logger
    attr_accessor :name, :source

    def initialize *args
      @load_state_mutex = Mutex.new
      @data_mutex = Mutex.new
      super
    end

    ###########################
    # Hash-like

    def [] k
      data[k]
    end

    def key? k
      data.key?(k)
    end

    def keys
      data.keys
    end

    def values
      data.values
    end

    def each &blk
      data.each &blk
    end

    ###########################
    # Data loading
    #

    def data
      check_load!
      raise Error, "data not available" unless @data
      @data
    end

    def data= x
      @data = x
    end

    def << layer
      unload!
      source << layer
      self
    end

    def synchronize
      @data_mutex.synchronize do
        yield
      end
    end

    def check_load! env = nil
      load!(env) unless @load_state == :loaded || @load_state == :loading
      self
    end

    def _load! *args
      synchronize do
        data = source.call(args.first || @data || { })
        # Deep.deep_freeze!(data)
        @data = data
      end
      @data
    end

    def _unload!
    end

    ###########################
    # Source-like

    def call env
      check_load!(env)
      data
    end

    ###########################

    def inspect_ivars
      [ :name, :load_state ]
    end
  end
end

