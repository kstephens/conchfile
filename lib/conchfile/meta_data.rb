require 'conchfile/initialize'
require 'conchfile/inspect'
require 'mime-types'
require 'time'

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
  end
end
