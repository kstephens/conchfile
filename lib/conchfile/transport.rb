require 'conchfile/initialize'
require 'conchfile/inspect'
require 'conchfile/logger'
require 'conchfile/meta_data'

require 'uri'
require 'conchfile/uri_agent'

module Conchfile
  class Transport
    include Initialize, Inspect, Logger
    attr_accessor :name, :uri, :mime_type, :uri_agent, :ignore_error

    def uri= x
      @uri = x && (URI === x ? x : URI.parse(x))
      @uri.scheme ||= 'file' if @uri
    end

    def call env
      raise Error, "no uri specified" unless uri
      begin
        get uri, env
      rescue => exc
        if ignore_error
          logger.warn { "#{self.class} #{name} : #{uri} : ignoring error : #{exc.inspect}" }
          nil
        else
          raise
        end
      end
    end

    def get uri, env
      uri_agent.get(uri)
    end

    def delete env
      uri_agent.delete(uri)
    end

    def put content, env
      uri_agent.put(content, uri)
    end

    def uri_agent
      @uri_agent || UriAgent.new
    end

    def inspect_ivars
      [ :name, :uri ]
    end
  end
end

