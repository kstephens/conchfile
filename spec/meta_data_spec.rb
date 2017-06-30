require 'spec_helper'
require 'conchfile/meta_data'

module Conchfile
  RSpec.describe MetaData do
    describe "Marshal.dump/load" do
      it "should not raise" do
        value = "a-string"
        WithMetaData[value]
        value.meta_data.source = Mutex.new
        expect(Marshal.load(Marshal.dump(value))) .to eq "a-string"
      end
    end
  end
end
