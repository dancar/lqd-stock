require 'sinatra'
set :public_folder, 'public'
data = []

get '/' do
  @data = data
  erb :"index.html"

end

post '/update' do
  request.body.rewind
  item = JSON.parse(request.body.read)

  # TODO: check request
  data.append(
    {
      stock: item["stock"],
      return_rate: item["return_rate"],
      max_drawdown: item["max_drawdown"],
      timestamp: Time.now.strftime("%d/%m/%Y %H:%M:%S")
    }
  )

end
