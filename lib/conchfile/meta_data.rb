require 'conchfile/initialize'
require 'conchfile/inspect'
require 'conchfile/deep'

module Conchfile
  class MetaData
    include Initialize, Inspect
    attr_accessor :uri, :uri_alt, :line, :mime_type, :source, :arg, :atime, :mtime, :http_headers

    def content
      self
    end

    def dup
      x = super
      x.uri = uri && uri.dup
      x
    end

    def self.[] obj
      respond_to?(:meta_data) and obj.meta_data or Empty
    end
    Empty = MetaData.new.freeze

    def inspect_ivars ; INSPECT_IVARS ; end
    INSPECT_IVARS = [ :uri, :uri_alt, :mime_type, :atime, :mtime ].freeze

    # Do not accidentally Marshal.dump :source,
    # since it contains state that:
    #
    # 1) cannot be serialized (e.g. Mutex)
    # 2) might leak unintended, sensitive data.
    #
    def marshal_dump
      nil
    end
    def marshal_load data
      self
    end
  end

  module WithMetaData
    attr_accessor :meta_data
    def self.[] data, opts = nil
      unless data.frozen?
        data.extend(self)
      end
      data.meta_data ||= MetaData === opts ? opts : MetaData.new(opts)
      data
    rescue
      data
    end

    def self.remove data
      f = lambda do | x |
        begin
          if WithMetaData === x
            x = x.dup
            x.remove_instance_variable(:'@meta_data')
          end
        rescue
        end
        x
      end
      Deep.deep_visit(data, f)
    end

  end
end
