require 'uri'

module Conchfile
  module URISupport
    def suffix uri = self
      uri.path && uri.path.to_s =~ /\.([^.]+)$/ && $1
    end

    def without_suffix uri = self
      uri = uri.dup
      uri.path &&= uri.path.sub(%r{\.[^.]+$}, '')
      uri
    end

    def without_user_pass uri = self
      if uri.user || uri.password
        uri = uri.dup
        uri.user &&= 'U'
        uri.password &&= 'P'
      end
      uri
    end
    
    ::URI::Generic.send(:include, self)
  end
end
