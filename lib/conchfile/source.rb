require 'conchfile/lazy_load'
require 'conchfile/deep'
require 'thread'

module Conchfile
  module HashLike
    ::Hash.send(:include, self)
  end

  class Source
    class Error < Conchfile::Error; end

    include Initialize, Logger
    attr_accessor :name, :transport, :format

    def format
      @format || Format::Auto.new
    end

    def call env
      content = transport.call(env)
      return WithMetaData[{ }, source: self, atime: Time.now] if content.nil?
      logger.debug { "#{self.class} : Fetched content #{content.meta_data.inspect} from #{transport.inspect}" }

      content.meta_data.source ||= self

      format = self.format

      ap(class: self.class,
         format: format.class,
         content: [ content.class, content.meta_data ]) if @debug

      data = nil
      begin
        data = format.call(content, env)
      rescue => exc
        exc = Error.new("#{self.class} : in #{content.meta_data.uri}: #{exc.inspect}")
        logger.error exc
        raise exc, exc.message, $!.backtrace
      end

      WithMetaData[data]

      ap(class: self.class,
         format: format.class,
         data: [ data.class, data.meta_data ]) if @debug

      data
    end

    def inspect
      "#<#{self.class} #{name.inspect} #{inspect_inner}>"
    end

    def inspect_inner
      transport.inspect
    end
  end
end

