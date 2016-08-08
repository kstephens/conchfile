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
      it "reads from file:// uri" do
        expect(subject.call(env))
          .to eq({a: 1,
                  b: 2,
                  c: ['d', 'e', 'f']})
      end
    end
  end
end
