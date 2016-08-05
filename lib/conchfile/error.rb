require 'conchfile/meta_data'

module Conchfile
  class Error < ::StandardError
    include WithMetaData
  end
end

