require 'net/http'
require 'uri'

module Conchfile
  class UriAgent
    class Error < Conchfile::Error; end
    include Initialize, Inspect, Logger
    attr_accessor :headers

    def get uri, headers = nil
      content = nil
      meta_data = MetaData.new(uri: uri)
      case uri.scheme
      when nil, "file"
        content = File.read(uri.path)
        meta_data.mtime = File.mtime(uri.path)
      else
        http(uri, Net::HTTP::Get, nil, headers) do | res |
          check_status! :GET, res
          content = res.body
          set_meta_data! meta_data, res
        end
      end
      meta_data.atime = Time.now
      WithMetaData[content, meta_data]
    end

    def set_meta_data! meta_data, res
      h = res.header
      meta_data.http_headers = h
      if v = h['Content-Type'] #  and v = v.first
        meta_data.mime_type = MIME::Types[v].first
      end
      if v = h['Last-Modified'] # and v = v.first
        meta_data.mtime = Time.rfc2822(v)
      end
      meta_data
    end

    def delete uri, headers = nil
      case uri.scheme
      when nil, "file"
        File.unlink(uri.path)
      else
        http(uri, Net::HTTP::Delete, nil, headers) do | res |
          check_status! :DELETE, res
        end
      end
    end

    def put content, uri, headers = nil
      case uri.scheme
      when nil, "file"
        File.write(uri.path, content)
      else
        http(uri, Net::HTTP::Put, content, headers) do | res |
          check_status! :PUT, res
        end
      end
    end

    def http uri, req, body, headers
      Net::HTTP.start(uri.host, uri.port,
                      use_ssl: uri.scheme == 'https'
                      ) do | http |
        h = (@headers || Empty_Hash).merge(headers || Empty_Hash)
        request = req.new(uri)
        unless body.nil?
          request.body = body
          if mime_type = MetaData[body].mime_type
            h['Content-Type'] = mime_type.to_s
          end
        end
        h.each do | k, v |
          request[k] = v
        end
        response = http.request(request)
        yield response
      end
    end

    def check_status! method, res
      unless res.code.to_i == 200
        msg = "#{method} #{uri} status #{res.code}"
        logger.error "#{self.class} : #{msg}"
        raise Error, msg
      end
    end

    Empty_Hash = { }.freeze
  end
end
