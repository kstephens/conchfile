require 'spec_helper'
require 'conchfile/transport'

module Conchfile
  describe Transport do
    subject do
      Transport.new(opts)
    end
    let(:opts) { {uri: uri} }
    let(:env) { { } }

    context "#call" do
      context "for file:/// URI" do
        let(:uri) { "file://#{File.expand_path(__FILE__)}" }
        it "reads from file" do
          expect(subject.call(env)) .to eq(File.read(__FILE__))
        end
      end

      context "for file URI" do
        let(:uri) { __FILE__ }
        it "reads from file" do
          expect(subject.call(env)) .to eq(File.read(__FILE__))
        end
      end

      context "for file URI" do
        let(:uri) { __FILE__ }
        let(:meta_data) { subject.call(env).meta_data }
        it "expects meta_data" do
          expect(meta_data.uri.to_s)
            .to eq("file:#{File.expand_path(uri)}")
          expect(meta_data.mtime)
            .to eq(File.mtime(uri))
          expect(meta_data.mime_type)
            .to eq(nil)
        end
      end
    end
  end
end
