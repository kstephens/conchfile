module Conchfile
  module Deep
    def deep_merge a, b
      if Hash === a and Hash === b
        result = { }
        # meta_data = WithMetaData[a].meta_data
        (a.keys | b.keys).each do | k |
          result[k] =
            case
            when a.key?(k) && b.key?(k)
              deep_merge(a[k], b[k])
            when a.key?(k) && ! b.key?(k)
              a[k]
            else
              b[k]
            end
        end
        # result.meta_data = meta_data
        result
      else
        b
      end
    end

    def deep_walk x, vf = nil, kf = nil
      case x
      when Hash
        result = { }
        x.each do | k, v |
          k = kf[k] if kf
          result[k] = deep_walk(v, vf, kf)
        end
        x = result
      when Enumerable
        x = x.map do | v |
          deep_walk(v, vf, kf)
        end
      end
      vf ? vf[x] : x
    end

    def deep_walk! x, vf = nil, kf = nil
      case x
      when Hash
        copy = x.dup
        x.clear
        copy.each do | k, v |
          k = kf[k] if kf
          x[k] = deep_walk!(v, vf, kf)
        end
      when Enumerable
        x.map! do | v |
          deep_walk!(v, vf, kf)
        end
      end
      vf ? vf[x] : x
    end

    def deep_symbolize! x
      deep_walk!(x,
        nil,
        lambda{|k| k.respond_to?(:to_sym) ? k.to_sym : k })
    end

    def deep_visit x, f
      deep_walk(x, f, f)
    end

    def deep_visit! x, f
      deep_walk!(x, f, f)
    end

    def deep_meta_data! data, md
      f = lambda { | x |
        WithMetaData[x, md]
      }
      deep_walk!(data, f, f)
    end

    def deep_freeze! x
      unless x.frozen?
        case x
        when Hash
          x.each do | k, v |
            deep_freeze!(k)
            deep_freeze!(v)
          end
        when Enumerable
          x.each do | v |
            deep_freeze!(v)
          end
        end
        x.freeze rescue nil
      end
      x
    end

    extend self
  end
end
