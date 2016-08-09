require 'spec_helper'
require 'conchfile/transport'

module Conchfile
  describe Transport do
    subject do
      Transport.new(opts)
    end
    let(:opts) { nil }
    let(:env) { { } }

    context "#call" do
      context "for file:/// URI" do
        let(:opts) { {uri: "file://#{File.expand_path(__FILE__)}"} }
        it "reads from file" do
          expect(subject.call(env)) .to eq(File.read(__FILE__))
        end
      end
      context "for file URI" do
        let(:opts) { {uri: __FILE__} }
        it "reads from file" do
          expect(subject.call(env)) .to eq(File.read(__FILE__))
        end
      end
    end

    context "#uri_" do
      context "for file path" do
        let(:opts) { {uri: "foo/bar"} }
        let(:result) { subject.uri_(env) }
        it "returns a valid file:// URI" do
          expect(result.scheme) .to eq('file')
          expect(result.host)   .to eq(nil)
          expect(result.path)   .to eq('foo/bar')
        end
      end
    end
  end
end
