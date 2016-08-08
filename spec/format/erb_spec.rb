require 'spec_helper'
require 'conchfile/format/erb'

module Conchfile; class Format
  describe Erb do
    subject do
      Erb.new(opts.merge(format: Format.new))
    end
    let(:opts) { { } }
    let(:env) { { } }

    context "#call" do
      context "for non-erb data" do
        it "does not erb for non-erb" do
          expect(subject.call("foobar", env)) .to eq("foobar")
          expect(subject.call("<%= 2 + 3 %>", env)) .to eq("<%= 2 + 3 %>")
        end
      end

      context "when erb: true" do
        let(:opts) { {erb: true} }
        it "uses erb" do
          expect(subject.call("foobar", env)) .to eq("foobar")
          expect(subject.call("<%= 2 + 3 %>", env)) .to eq("5")
        end
      end

      context "when has ERB header" do
        let(:header) { "# -*- erb -*-\n" }
        it "uses erb" do
          expect(subject.call("#{header}<%= 2 + 3 %>", env)) .to eq("#{header}5")
        end
      end
    end
  end
end; end
