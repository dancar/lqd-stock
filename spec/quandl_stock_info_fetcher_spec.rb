require './spec/spec_helper'
require './lib/quandl_stock_info_fetcher'
describe QuandlStockInfoFetcher do
  TEST_URL_TEMPLATE = "http://not-quandl.com/%{stock}"
  sample_body = File.read('./spec/fixtures/body1.json')
  sample_body2 = File.read('./spec/fixtures/body2.json')
  sample_body3 = File.read('./spec/fixtures/body3.json')
  sample_body4 = File.read('./spec/fixtures/body4.json')
  before  do
    stub_request(:get, "http://not-quandl.com/test_data1?api_key=my_great_key&start_date=2015-02-02").
      to_return(status: 200, body: sample_body, headers: {})
    stub_request(:get, "http://not-quandl.com/test_data2?api_key=my_great_key&start_date=2015-02-02").
      to_return(status: 200, body: sample_body2, headers: {})
    stub_request(:get, "http://not-quandl.com/test_data3?api_key=my_great_key&start_date=2015-02-02").
      to_return(status: 200, body: sample_body3, headers: {})
    stub_request(:get, "http://not-quandl.com/test_data4?api_key=my_great_key&start_date=2015-02-02").
      to_return(status: 200, body: sample_body4, headers: {})
    @fetcher = QuandlStockInfoFetcher.new(TEST_URL_TEMPLATE)
  end

  it "fetch with no errors" do
    success, info = @fetcher.get_info("test_data1", "2015-02-02")
    expect(success).to equal :success
    expect(info).to be_kind_of(Hash)
  end

  it "should calculate return correctly" do
    _, info = @fetcher.get_info("test_data1", "2015-02-02")
    value_final = 178.32
    value_initial = 181.46
    expected_return = ((value_final - value_initial) / value_initial)
    expect(info[:return_value]).to eq(expected_return)

    _, info = @fetcher.get_info("test_data2", "2015-02-02")
    value_final = 200000.0
    value_initial = 100000.0
    expected_return = ((value_final - value_initial) / value_initial)
    expect(info[:return_value]).to eq(expected_return)

    _, info = @fetcher.get_info("test_data3", "2015-02-02")
    value_final = 800.0
    value_initial = 500.0
    expected_return = ((value_final - value_initial) / value_initial)
    expect(info[:return_value]).to eq(expected_return)
  end

  it "should calculate MDD correctly" do
    _, info = @fetcher.get_info("test_data2", "2015-02-02")
    max_drawdown = (150000.0 - 80000) / 150000
    expect(info[:max_drawdown]).to eq(max_drawdown)

    _, info = @fetcher.get_info("test_data3", "2015-02-02")
    max_drawdown = (750 - 350.0 ) / 750
    expect(info[:max_drawdown]).to eq(max_drawdown)

    _, info = @fetcher.get_info("test_data4", "2015-02-02")
    max_drawdown = (150000.0 - 80000) / 150000
    expect(info[:max_drawdown]).to eq(max_drawdown)
  end

  it "should return dates correctly" do
    _, info = @fetcher.get_info("test_data1", "2015-02-02")
    expect(info[:first_date]).to eq Date.parse "2018-02-27"
    expect(info[:last_date]).to eq Date.parse "2018-02-28"

    _, info = @fetcher.get_info("test_data2", "2015-02-02")
    expect(info[:last_date]).to eq Date.parse "2018-02-25"
    expect(info[:first_date]).to eq Date.parse "2018-02-20"
  end
end
