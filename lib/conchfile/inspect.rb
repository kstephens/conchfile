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
          .each   {|x| x[1] = x[1].inspect }
        ) .join(' ') << ">"
    end

    def inspect_ivars
      instance_variables
    end
  end
end
