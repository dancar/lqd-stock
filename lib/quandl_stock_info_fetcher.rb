require 'json'
require 'net/http'
require 'date'
require './lib/settings'

DAYS_PER_YEAR = 365

class QuandlStockInfoFetcher
  API_URL_TEMPLATE =  "https://www.quandl.com/api/v3/datasets/WIKI/%{stock}"
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

  def initialize(url_template = API_URL_TEMPLATE)
    @url_template = url_template
    @settings = Settings[:quandl]
  end

  # TODO REMOVE
  def development_data()
    JSON.parse(File.read('./data.json')).map {|day| Hash[day.map {|str, val| [API_DAY_DATA_STR_TO_SYM[str], val]}]}
  end

  def fetch_info(stock, date)
    api_key = @settings[:api_key]
    uri = URI(@url_template % {stock: stock})
    params = {
      api_key: api_key,
      start_date: date,
    }
    uri.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(uri)
    data = JSON.parse(response.body)["dataset"]

    # TODO: handle errors? including empty data

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
    annual_return_rate = ret / (1.0 * duration_days / DAYS_PER_YEAR)

    max_drawdown = find_mmd (data)

    {
      max_drawdown: max_drawdown,
      first_date: first_date,
      last_date: last_date,
      initial_value: initial_value,
      final_value: final_value,
      return_value: ret,
      return_rate: annual_return_rate,
      duration_days: duration_days,
    }
  end

  def  find_mmd(data)
    # TODO: check, test!
    peak =  data[-1][:close]
    max_drawdown = 0

    data.reverse_each do |day|
      next if day == data[-1]
      value = day[:close]
      if value > peak
        peak = value
      else
        drawdown = (peak.to_f - value ) / peak
        max_drawdown = [max_drawdown, drawdown].max
      end
    end
    max_drawdown
  end

  def get_info(stock, date)
    stock_data = fetch_info(stock, date)
    return :no_data, [] if stock_data.length == 0
    data = calculate_data(stock_data)
    data[:stock] = stock
    return :success, data
  end
end
