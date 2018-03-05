require './lib/settings'
describe Settings do
  before { @settings = Settings.new("./spec/test_settings.yml", "./spec/test_settings_local.yml")}

  it { should be_kind_of(Hash) }
  it "should correctly load a settings file" do
    expect(@settings[:some_true_value]).to be true
    expect(@settings[:some_string]).to eq "stringy!"
  end

  it "should correctly override nested settings with local_settings" do
    expect(@settings[:some_hash][:some_inner_hash][:some_value]).to eq("I am settings, too")
    expect(@settings[:some_hash][:some_inner_hash][:some_overriden_value]).to eq("I am LOCAL settings")
  end
end
