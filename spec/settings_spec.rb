require './lib/settings'
require './spec/spec_helper'
describe Settings do

  it "should correctly load a settings file" do
    expect(Settings[:some_true_value]).to be true
    expect(Settings[:some_string]).to eq "stringy!"
  end

  it "should correctly symbolize nested settings" do
    expect(Settings[:some_hash][:some_inner_hash][:some_value]).to eq "nested!"
  end

end
