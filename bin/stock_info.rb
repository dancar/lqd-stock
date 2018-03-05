require 'pp' #TODO: remove?
require './lib/quandl_stock_info_fetcher'
require './lib/publishers/console_publisher'
require './lib/publishers/email_publisher'
require './lib/publishers/twitter_publisher'
require './lib/publishers/lqd_page_publisher'
require './lib/settings'

# TODO: safely check settings file:
# TODO specify date ranger, everywhere
# TODO Tests
# TODO: split requests to some maximum to avoid too big responses?
# TODO another API?

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
  publisher_settings = Settings[:publishers]
  PUBLISHERS.each do | settings_key, klass|
    if publisher_settings[settings_key][:enable]
      publisher = klass.new
      publisher.publish(info)
    end
  end
end

args_ok = check_args(stock, date)
if args_ok
  info = QuandlStockInfoFetcher.new().get_info(stock, date)
  publish(info)
end
