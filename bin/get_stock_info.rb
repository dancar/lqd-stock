require 'pp' #TODO: remove?
require './lib/stock_info'
require './lib/publishers/console_publisher'
require './lib/publishers/email_publisher'
require './lib/publishers/twitter_publisher'
require './lib/publishers/lqd_page_publisher'
require './lib/settings'

# TODO: safely check settings file:
# TODO: split requests to some maximum to avoid too big responses?

PUBLISHERS = {
  console: ConsolePublisher,
  email: EmailPublisher,
  twitter: TwitterPublisher,
  lqd_page: LqdPagePublisher,
}

stock, date = ARGV
def check_args(stock, date)
  # TODO implement
  true
end

def publish(info)
  publisher_settings = Settings.new()[:publishers]
  PUBLISHERS.each do | settings_key, klass|
    if publisher_settings[settings_key][:enable]
      publisher = klass.new
      publisher.publish(info)
    end
  end
end

args_ok = check_args(stock, date)
if args_ok
  info = StockInfo.new().get_info(stock, date)
  publish(info)
end
