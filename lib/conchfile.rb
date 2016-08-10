require "conchfile/version"
require 'conchfile/hash_like'

require 'uri'
class URI::Generic
  def suffix
    path && path.to_s =~ /\.([^.]+)$/ && $1
  end
  def without_suffix
    uri = self.dup
    uri.path &&= uri.path.sub(%r{\.[^.]+$}, '')
    uri
  end
end

require 'conchfile/error'
require 'conchfile/inspect'
require 'conchfile/logger'
require 'conchfile/initialize'
require 'conchfile/meta_data'
require 'conchfile/root'
require 'conchfile/source'
require 'conchfile/source/layer'
require 'conchfile/format'
require 'conchfile/format/mime_types'
require 'conchfile/format/auto'
require 'conchfile/format/symbolize'
require 'conchfile/transport'
