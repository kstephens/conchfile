
module Conchfile
  module HashLike
    ::Hash.send(:include, self)
  end

  class Source
    class Error < Conchfile::Error; end

    include Initialize, Inspect, Logger, LoadState
    attr_accessor :name, :transport, :format

    def initialize *args
      initialize_load
      super
    end

    def format
      @format || Format::Symbolize.new(format: Format::Auto.new)
    end

    def call env
      content = fetch(env)
      return WithMetaData[{ }, source: self, atime: Time.now] if content.nil?
      parse(content, env)
    end

    def fetch env
      content = nil
      begin
        content = transport.call(env)
      rescue => exc
        exc = Error.new("#{self.class} #{name} : in #{transport.inspect}: #{exc.inspect}")
        logger.error exc
        raise exc, exc.message, $!.backtrace
      end

      return nil if content.nil?

      WithMetaData[content]
      logger.debug { "#{self.class} #{name} : Fetched content #{content.meta_data.inspect} from #{transport.inspect}" }

      content.meta_data.source ||= self

      ap(class:    self.class,
         format:   format.class,
         content:  [ content.class, content.meta_data ]) if @debug

      content
    end

    def parse content, env
      data = nil

      format = self.format
      begin
        data = format.call(content, env)
      rescue => exc
        exc = Error.new("#{self.class} #{name} : in #{content.meta_data.uri}: #{exc.inspect}")
        logger.error exc
        raise exc, exc.message, $!.backtrace
      end

      WithMetaData[data]

      ap(class:   self.class,
         format:  format.class,
         data:    [ data.class, data.meta_data ]) if @debug

      data
    end

    def _load!
    end

    def _unload!
    end

    def inspect_ivars
      [ :name, :transport ]
    end
  end
end

