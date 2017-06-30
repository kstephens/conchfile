require 'spec_helper'
require 'conchfile/source'
require 'conchfile/format/yaml'

module Conchfile
  describe Source do
    subject do
      Source.new(opts.merge(transport: transport, format: format))
    end
    let(:opts) { { } }
    let(:env) { { } }
    let(:content) do
      <<'END'
a: 1
b: 2
c: [ d, e, f ]
END
    end
    let(:transport) do
      lambda do | env |
        content
        WithMetaData[content, {mime_type: 'text/x-yaml'}]
      end
    end
    let(:format) do
      nil
    end

    context "#call" do
      let(:result) { subject.call(env) }
      it "reads from file:// uri" do
        expect(result)
          .to eq({a: 1,
                  b: 2,
                  c: ['d', 'e', 'f']})
      end
      it "returns values with MetaData" do
        expect(result[:c].meta_data.source) .to equal subject
      end
    end
  end
end
