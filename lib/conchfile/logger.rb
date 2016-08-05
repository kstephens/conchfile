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
  end
end
