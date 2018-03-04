class ConsolePublisher
  MESSAGE_TEMPLATE = <<~TEMPLATE
    Stock Update: %{stock}
    Rate of Return: %{return_rate}
    Max Drawdown: %{max_drawdown}
  TEMPLATE

  def publish(info)
    puts(MESSAGE_TEMPLATE % info)
  end
end
