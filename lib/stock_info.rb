class StockInfo < Hash

  def percent(f)
    "%0.2f%%" % (f * 100)
  end

  def initialize(info = {})
    super()
    self.merge!(info)
  end

  def to_s
    str = <<~STR
        Stock Update: %{stock}
        First Date: %{first_date}
        Last Date: %{last_date}
        Return: #{percent(self[:return_value])}
        Max Drawdown: #{percent(self[:max_drawdown])}
    STR
    str % self
  end

end
