require 'time'
require 'date'
require 'uri'

module Conchfile
  module Inspect
    def inspect opt = nil
      return super if opt == :super
      attrs =
        (
        [ "#<#{self.class}" ] +
        inspect_ivars
          .map    {|a| [ a, instance_variable_get("@#{a}") ] }
          .select {|x| ! x[1].nil? }
          .each   do |x|
          x[1] = case y = x[1]
                 when ::Time
                   y.iso8601(3)
                 when ::Date
                   y.to_s
                 when ::URI
                   (y.without_user_pass.to_s rescue nil) or y.to_s
                 else
                   y.inspect
                 end
        end
        ) .join(' ') << ">"
    end

    def inspect_ivars
      instance_variables
    end
  end
end
