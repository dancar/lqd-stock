require 'webmock/rspec'
require './lib/settings'

WebMock.disable_net_connect!(:allow_localhost => false)
Settings.init("./spec/test_settings.yml")
