require 'pp' #TODO: remove?
require './lib/stock_info'

# TODO: safely check settings file:
# TODO: split requests to some maximum to avoid too big responses?

stock, date = ARGV
def check_args(stock, date)
  # TODO implement
  true
end

args_ok = check_args(stock, date)
if args_ok
  res = StockInfo.new().get_info(stock, date)
  PP.pp res
  StockInfoPublisher.publish(res)
end
