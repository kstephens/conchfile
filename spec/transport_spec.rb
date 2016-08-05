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
      context "for file" do
        let(:opts) { {file: __FILE__} }
        it "reads from file" do
          expect(subject.call(env)) .to eq(File.read(opts[:file]))
        end
      end

      context "for uri" do
        let(:opts) { {uri: "file://#{File.expand_path(__FILE__)}"} }
        it "reads from file:// uri" do
          expect(subject.call(env)) .to eq(File.read(__FILE__))
        end
      end
    end
  end
end
