module Conchfile
  module Initialize
    def initialize args = nil
      args.each do | k, v |
        s = :"#{k}="
        send(s, v) if respond_to? s
      end if args
    end
  end
end
