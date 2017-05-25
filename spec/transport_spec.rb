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

      context "with timeout" do
        let(:uri) { __FILE__ }
        let(:opts) { { uri: uri, timeout: 0.02, logger: logger } }
        let(:mock) do
          def subject._get *args
            sleep 1
          end
          subject
        end
        it "raises error and logs ERROR" do
          expect do
            mock.call(env)
          end .to raise_error(Conchfile::Error::Timeout)
          expect(logger_output) .to match(%r{ERROR .* Conchfile::Transport .* timeout .* #<Conchfile::Error::Timeout})
        end
        context "with :ignore_error" do
          let(:opts) { { uri: uri, timeout: 0.02, logger: logger, ignore_error: true } }
          it "returns nil and logs ERROR" do
            expect(mock.call(env)) .to be_nil
            expect(logger_output) .to match(%r{ERROR .* Conchfile::Transport .* timeout .* #<Conchfile::Error::Timeout})
          end
        end
      end
    end
  end
end
