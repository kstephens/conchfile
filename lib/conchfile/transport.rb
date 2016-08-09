require 'conchfile/initialize'
require 'conchfile/inspect'
require 'conchfile/logger'
require 'conchfile/meta_data'

require 'uri'
require 'open-uri'
require 'mime-types'

module Conchfile
  class Transport
    include Initialize, Inspect, Logger
    attr_accessor :uri, :file, :ignore_error

    def call env
      unless u = determine_uri(env)
        raise Error, "no :uri or :file specified"
      end
      begin
        unless URI === u
          u = u.to_s.sub(%r{^file:///\./}, "file://#{File.expand_path('.')}")
          u = URI.parse(u)
        end
        fetch_uri(u)
      rescue => exc
        if ignore_error
          logger.warn { "#{self.class} : #{u} : ignoring error : #{exc.inspect}" }
          nil
        else
          raise
        end
      end
    end

    def determine_uri(env)
      u = uri
      u ||= "file://#{File.expand_path(file)}" if file
      u
    end

    def fetch_uri u
      now = Time.now
      meta_data = MetaData.new(uri: u, atime: now)
      case u.scheme
      when nil, "file"
        data = File.read(u.path)
        meta_data.mtime = File.mtime(u.path)
      else
        data = OpenURI.open_uri(u) do |f|
          meta_data.http_headers = h = f.meta
          content_type = h['content-type']
          meta_data.mime_type = MIME::Types[content_type].first if content_type
          last_modified = h['last-modified']
          meta_data.mtime = Time.rfc2822(last_modified) if last_modified
          f.read
        end
      end
      WithMetaData[data, meta_data]
    end

    def inspect_ivars
      [ :uri, :file ]
    end
  end
end

