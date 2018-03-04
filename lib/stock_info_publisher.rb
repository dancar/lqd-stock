require 'pp'
require 'net/http'
require './lib/settings'

class StockInfoPublisher
  def initialize()
    @settings = Settings.new()["publishing"]
  end

  def publish(info)
    if @settings["console"]
      pp info
    end

    if @settings["twitter"]
  end
end
