require 'yaml'
require 'json'
require 'net/http'
require 'date'
require 'pp' #TODO: remove?

SETTINGS_FILE = './settings.yml'
DATE_FORMAT = "yyyy-mm-dd"

class StockInfo

  API_DAY_DATA_STR_TO_SYM = {
    "Date" => :date,
    "Open" => :open,
    "High" => :high,
    "Low" => :low,
    "Close" => :close,
    "Volume" => :volume,
    "Ex-Dividend" => :ex_dividend,
    "Split Ratio" => :split_ratio,
    "Adj. Open" => :adj_open,
    "Adj. High" => :adj_high,
    "Adj. Low" => :adj_low,
    "Adj. Close" => :adj_close,
    "Adj. Volume" => :adj_volume,
  }

  def initialize()
    settings = YAML.load_file(SETTINGS_FILE)
    @api_key = settings["api_key"]
    @url_template = settings["url_template"]
  end

  # TODO REMOVe
  def development_data()
    JSON.parse(File.read('./data.json')).map {|day| Hash[day.map {|str, val| [API_DAY_DATA_STR_TO_SYM[str], val]}]}
  end

  def fetch_info(stock, date)
    return development_data()

    uri = URI(@url_template % {stock: stock})
    params = {
      start_date: date
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    data = JSON.parse(response.body)["dataset"] #["data"]
    # TODO: handle errors?
    column_names = data["column_names"].map {|str| API_DAY_DATA_STR_TO_SYM[str] }
    stock_data = data["data"].map{ |day| Hash[column_names.zip(day)]}
    stock_data
  end

  def calculate_data(data)
    first_day = data[-1]
    last_day = data[0]

    initial_value = first_day[:close]
    final_value = last_day[:close]

    first_date = Date.parse(first_day[:date])
    last_date = Date.parse(last_day[:date])

    duration_days = last_date.mjd - first_date.mjd
    ret = (final_value - initial_value) / initial_value
    annual_return_rate = ret / (duration_days / 365)
    {
      first_date: first_date,
      last_date: last_date,
      initial_value: initial_value,
      final_value: final_value,
      return_value: ret,
      return_rate: annual_return_rate,
      duration_days: duration_days,
    }
  end

  def get_info(stock, date)
    stock_data = fetch_info(stock, date)
    data = calculate_data(stock_data)
    data
  end
end
# TODO: safely check settings file:
# TODO: split requests to some maximum to avoid too big responses


stock, date = ARGV
# puts "Stock: #{stock}"
# puts "Date: #{date}"

def check_args(stock, date)
  # TODO implement
  true
end

args_ok = check_args(stock, date)
if args_ok
  res = StockInfo.new().get_info(stock, date)
  PP.pp res
  # puts res.select{|day| day["Ex-Dividend"] > 0}
end
