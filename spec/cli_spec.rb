require './lib/cli'
require './spec/spec_helper'
describe CLI do
  it "Should correctly fail on argumenst" do
    exit_code = CLI.new(false).run("hello", "world")
    expect(exit_code).to eq(CLI::ERROR_BAD_ARGUMENTS)

    exit_code = CLI.new(false).run("hell", "world")
    expect(exit_code).to eq(CLI::ERROR_BAD_ARGUMENTS)

    exit_code = CLI.new(false).run("hell", nil)
    expect(exit_code).to eq(CLI::ERROR_BAD_ARGUMENTS)

    exit_code = CLI.new(false).run("", "2015-02-01")
    expect(exit_code).to eq(CLI::ERROR_BAD_ARGUMENTS)

    exit_code = CLI.new(false).run("BAD", "0000-00-00")
    expect(exit_code).to eq(CLI::ERROR_BAD_ARGUMENTS)
  end
end
