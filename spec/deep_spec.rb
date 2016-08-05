require 'conchfile/deep'

module Conchfile
  describe Deep do
    M = Deep

    context "#deep_merge" do
      it "returns second arg for non-Hash" do
        expect(M.deep_merge(nil   , nil)) .to eq(nil)
        expect(M.deep_merge(false , nil)) .to eq(nil)
        expect(M.deep_merge(false , false)) .to eq(false)
        expect(M.deep_merge(nil   , false)) .to eq(false)
        expect(M.deep_merge(nil   , 1)) .to eq(1)
        expect(M.deep_merge(1     , nil)) .to eq(nil)
        expect(M.deep_merge(2     , [])) .to eq([])
      end
      it "merges Hash" do
        # expect(M.deep_merge({a: 1}, nil)) .to eq({a: 1})
        expect(M.deep_merge({a: 1},
                       {})) .to eq({a: 1})
        expect(M.deep_merge({},
                       {a: 1})) .to eq({a: 1})
        expect(M.deep_merge({a: 1},
                       {a: 2})) .to eq({a: 2})
        expect(M.deep_merge({a: 1},
                       {b: 2})) .to eq({a: 1, b: 2})
        expect(M.deep_merge({a: 1, b: {c: 1, d: 5}},
                       {a: 1, b: {c: 2, e: 7}}))
          .to eq({a: 1, b: {c: 2, d: 5, e: 7}})
      end
    end

    context "#deep_walk" do
      it "walks applying vf" do
        expect(M.deep_walk(1,
                    lambda{|x| Numeric === x ? x + 2 : x}, nil))
          .to eq 3
        expect(M.deep_walk([1, 2, 3],
                    lambda{|x| Numeric === x ? x + 3 : x}, nil))
          .to eq [ 4, 5, 6 ]
        expect(M.deep_walk({a: 1, b: 2},
                    lambda{|x| Numeric === x ? x + 5 : x}, nil))
          .to eq({a: 6, b: 7})
      end
      it "deep_walks applying kf" do
        expect(M.deep_walk(1,
                           nil,
                           :to_sym.to_proc))
          .to eq 1
        expect(M.deep_walk([1, 2, 3],
                           nil,
                           :to_sym.to_proc))
          .to eq([1, 2, 3])
        expect(M.deep_walk({a: 1, "b" => 2},
                           nil,
                           :to_sym.to_proc))
          .to eq({a: 1, b: 2})
      end
    end
  end
end
