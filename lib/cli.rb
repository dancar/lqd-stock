require './lib/quandl_stock_info_fetcher'
require './lib/publishers/console_publisher'
require './lib/publishers/email_publisher'
require './lib/publishers/twitter_publisher'
require './lib/publishers/lqd_page_publisher'
require './lib/settings'

class CLI
  ERROR_NO_SETTINGS_FILE = 3
  ERROR_BAD_ARGUMENTS = 2
  ERROR_NO_DATA = 1
  SUCCESS = 0
  PUBLISHERS = {
    console: ConsolePublisher,
    email: EmailPublisher,
    twitter: TwitterPublisher,
    lqd_page: LqdPagePublisher,
  }

  USAGE =<<~USAGE
    Usage:
    $ ruby bin/get_stock_info.rb [STOCK] [DATE]

    [DATE] Format: yyyy-mm-dd
    [STOCK] Format: 1-4 alphanumeric characters

    Example:

    $ ruby bin/get_stock_info.rb FB 2018-02-25
  USAGE

  def initialize(allow_output = true)
    @allow_output = allow_output
  end

  def output(str)
    puts(str) if @allow_output
  end

  def check_args(stock, date)
    stock_regex = /^[[:alnum:]]{1,4}$/
    date_regex = /^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$/
    date_ok = Date.parse(date) rescue nil
    date_ok and stock and stock.match(stock_regex) and date.match(date_regex)
  end

  def run(stock, date)
    if !File.file?(Settings::SETTINGS_FILE)
      output "No Settings file found in '#{Settings::SETTINGS_FILE}' !\nPlease see README and settings.yml.example for more information."
      return ERROR_NO_SETTINGS_FILE
    end

    if not check_args(stock, date)
      output USAGE
      return ERROR_BAD_ARGUMENTS
    end

    status, info = QuandlStockInfoFetcher.new().get_info(stock, date)
    if status != :success
      output "Error loading data (#{status.to_s})"
      return ERROR_NO_DATA
    end
    publish(info)
    return SUCCESS
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
end
