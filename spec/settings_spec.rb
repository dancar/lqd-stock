require './lib/settings'
require './spec/spec_helper'
describe Settings do

  it "should correctly load a settings file" do
    expect(Settings[:some_true_value]).to be true
    expect(Settings[:some_string]).to eq "stringy!"
  end

  it "should correctly override nested settings with local_settings" do
    expect(Settings[:some_hash][:some_inner_hash][:some_value]).to eq("I am settings, too")
    expect(Settings[:some_hash][:some_inner_hash][:some_overriden_value]).to eq("I am LOCAL settings")
  end
end
