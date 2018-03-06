require './spec/spec_helper'
require './lib/quandl_stock_info_fetcher'
describe QuandlStockInfoFetcher do
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
    @fetcher = QuandlStockInfoFetcher.new()
  end

  it "fetch with no errors" do
    success, info = @fetcher.get_info("test_data1", "2015-02-02")
    expect(success).to equal :success
    expect(info).to be_kind_of(Hash)
  end

  it "should calculate rate of return correctly" do
    _, info = @fetcher.get_info("test_data1", "2015-02-02")
    value_final = 178.32
    value_initial = 181.46
    expected_return = ((value_final - value_initial) / value_initial)
    expected_ror = expected_return / (1.0 / 365) # one day
    expect(info[:return_value]).to eq(expected_return)
    expect(info[:return_rate]).to eq(expected_ror)
  end

  it "should calculate MDD correctly", focus: true do
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
end
