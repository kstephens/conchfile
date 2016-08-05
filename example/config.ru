require 'pp'
require 'mime-types'
require 'digest/md5'

run lambda { |env|
  file = "./#{env['REQUEST_URI']}"
  ext = file =~ /\.([^.]+)$/ && $1
  content_type = MIME::Types.find{|mt| mt.extensions.include?(ext)}
  content_type ||= 'text/plain'
  content = File.file?(file) ? File.read(file) : ''
  headers = {
    'Content-Type'  => content_type.to_s,
    'Last-Modified' => File.mtime(file).getutc.rfc2822,
    'ETag'          => Digest::MD5.hexdigest(content),
    'Cache-Control' => 'public, max-age=86400',
  }
  response = [ 200, headers, [ content ] ]
  pp(file: file, ext: ext, headers: headers)
  response
}
