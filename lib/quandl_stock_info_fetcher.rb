require 'json'
require 'net/http'
require 'date'
require './lib/settings'
require './lib/stock_info'


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
    response_body = response.body
    raise "Invalid response received from Quandl:\n%s" % response.body if !response.kind_of? Net::HTTPSuccess
    File.write('response_%s.json' % Time.now.to_f.to_s, response_body) if @settings[:dump_response]
    response_parsed = JSON.parse(response_body)
    data = response_parsed["dataset"]

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

    ret = (final_value.to_f - initial_value) / initial_value
    # TODO: calc dividens?

    max_drawdown = find_mmd(data)

    StockInfo.new({
      max_drawdown: max_drawdown,
      first_date: first_date,
      last_date: last_date,
      initial_value: initial_value,
      final_value: final_value,
      return_value: ret,
    })
  end

  def  find_mmd(data)
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
