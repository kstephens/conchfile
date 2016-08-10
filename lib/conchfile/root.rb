require 'conchfile/initialize'
require 'conchfile/hash_like'
require 'conchfile/inspect'
require 'conchfile/load_state'
require 'conchfile/meta_data'
require 'conchfile/logger'
require 'conchfile/deep'
require 'thread'

module Conchfile
  class Root
    class Error < Conchfile::Error; end

    include HashLike::Proxy, Initialize, Inspect, LoadState, WithMetaData, Logger
    attr_accessor :name, :source

    def initialize *args
      initialize_load
      @data_mutex = Mutex.new
      super
    end

    ###########################
    # Data loading

    # Lazily loads @data.
    def data
      check_load!
      raise Error, "data not available" unless @data
      @data
    end

    def data= x
      @data = x
    end

    def synchronize
      @data_mutex.synchronize do
        yield
      end
    end

    def check_load! env = nil
      load!(env) unless loaded?
      self
    end

    def _load! env = nil
      synchronize do
        data = source.call(env || @data || { })
        @data = data
      end
      self
    end

    def _unload!
      source.unload!
    end

    ###########################
    # Layer-like

    # Appends a source to an underlying Source::Layer.
    def << layer
      unload!
      source << layer
      self
    end

    ###########################
    # Hash-like

    alias :_delegate_data :data

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

