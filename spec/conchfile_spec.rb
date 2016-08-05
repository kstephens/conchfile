require 'spec_helper'

describe Conchfile do
  it 'has a version number' do
    expect(Conchfile::VERSION).not_to be nil
  end
end
