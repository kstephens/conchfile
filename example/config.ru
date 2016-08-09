require 'pp'
require 'mime-types'
require 'digest/md5'

run lambda { |env|
  status = 200
  headers = { }
  content = [ ]
  begin
    file = "public/#{env['REQUEST_URI']}"
    file.gsub!(%r{/+$}, '')
    file.gsub!(%r{/../}, '/')
    file.gsub!(%r{//}, '/')
    ext = file =~ /\.([^.]+)$/ && $1
    content_type = MIME::Types.find{|mt| mt.extensions.include?(ext)}
    content_type ||= 'text/plain'

    case method = env['REQUEST_METHOD']
    when 'GET'
      if content = (File.file?(file) && File.read(file) rescue nil)
        headers = {
          'Content-Type'  => content_type.to_s,
          'Last-Modified' => File.mtime(file).getutc.rfc2822,
          'ETag'          => Digest::MD5.hexdigest(content),
          'Cache-Control' => 'public, max-age=86400',
        }
      else
        status = 404
        content = "Not Found: #{file}"
      end
    when 'PUT'
      content = env['rack.input'].read
      # pp(content: content)
      File.write(file, content)
      headers = {
        'ETag' => Digest::MD5.hexdigest(content),
      }
      content = "PUT #{file}"
    when 'DELETE'
      File.unlink(file) rescue nil
      content = "DELETE #{file}"
    end
  rescue => exc
    status  = 500
    content = exc.inspect
  end
  content = content.to_s
  pp(method: method, file: file, ext: ext, headers: headers, content_size: content.size)
  response = [ status, headers, [ content.to_s ] ]

  response
}
