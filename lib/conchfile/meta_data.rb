require 'conchfile/initialize'
require 'mime-types'
require 'time'

module Conchfile
  class MetaData
    include Initialize
    attr_accessor :uri, :uri_alt, :line, :mime_type, :source, :arg, :atime, :mtime, :http_headers

    def content
      self
    end

    def dup
      x = super
      x.uri = uri && uri.dup
      x
    end

    def inspect opt = nil
      return super if opt == :super
      [ "#<#{self.class}",
        @uri,
        @uri_alt,
        @mtime && @mtime.iso8601(3),
        @atime && @atime.iso8601(3),
        mime_type,
      ].compact.join(' ') << ">"
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
  end
end
