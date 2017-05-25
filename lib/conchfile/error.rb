require 'conchfile/meta_data'

module Conchfile
  class Error < ::StandardError
    include WithMetaData
    class Timeout < self ; end
  end
end

