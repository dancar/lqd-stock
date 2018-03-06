require './lib/cli'

stock, date = ARGV
CLI.new().run(stock, date)
