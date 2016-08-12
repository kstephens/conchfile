require 'logger'

module Conchfile
  module Logger
    def self.logger
      Thread.current[:'Conchfile::Logger.logger'] or
        @@logger ||= ::Logger.new($stderr)
    end
    def self.logger= x
      @@logger = x
    end
    def logger
      @logger || Conchfile::Logger.logger
    end
    def logger= x
      @logger = x
    end

    def self.with_logger logger
      save = Thread.current[:'Conchfile::Logger.logger']
      begin
        Thread.current[:'Conchfile::Logger.logger'] = logger
        yield
      ensure
        Thread.current[:'Conchfile::Logger.logger'] = save
      end
    end
  end
end
