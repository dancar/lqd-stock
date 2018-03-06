require './lib/stock_info'
require './spec/spec_helper'
describe StockInfo do

  it "should correctly display percentages" do
    si = StockInfo.new(
      {

        first_date: "2012-12-12",
        last_date: "2012-12-12",
        stock: "test",
        return_value: 0,
        max_drawdown: 123.456,
      })
    str = si.to_s
    expect(str).to match(/12345[.]60%/)

    si = StockInfo.new(
      {
        first_date: "2012-12-12",
        last_date: "2012-12-12",
        stock: "test",
        max_drawdown: 0,
        return_value: 0.0012,
      })
    str = si.to_s
    expect(str).to match(/0[.]12%/)
  end

end
