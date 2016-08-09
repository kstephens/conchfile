require 'open-uri'
require 'uri'

module Conchfile
  class UriAgent
    include Initialize, Inspect, Logger
    attr_accessor :headers

    def get uri, headers = nil
      now = Time.now
      meta_data = MetaData.new(uri: uri, atime: now)
      case uri.scheme
      when nil, "file"
        content = File.read(uri.path)
        meta_data.mtime = File.mtime(uri.path)
      else
        data = OpenURI.open_uri(uri) do |f|
          meta_data.http_headers = h = f.meta
          content_type = h['content-type']
          meta_data.mime_type = MIME::Types[content_type].first if content_type
          last_modified = h['last-modified']
          meta_data.mtime = Time.rfc2822(last_modified) if last_modified
          f.read
        end
      end
      WithMetaData[content, meta_data]
    end

    def delete uri, headers = nil
      case uri.scheme
      when nil, "file"
        File.unlink(uri.path)
      else
        raise Error, "not implemented"
      end
    end

    def post content, uri, headers = nil
      case uri.scheme
      when nil, "file"
        File.write(uri.path, content)
      else
        raise Error, "not implemented"
      end
    end

    def headers
      @headers || Empty_Hash
    end
    Empty_Hash = { }.freeze
  end
end
