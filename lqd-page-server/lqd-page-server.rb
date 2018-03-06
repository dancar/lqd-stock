require 'json'
require 'sinatra'

DATA_FILE = './data.json'
MAX_ITEMS = 10 # Maximum number of Stock info records stored

set :public_folder, 'public'

data = File.file?(DATA_FILE) ? JSON.parse(File.read(DATA_FILE)) : []

get '/' do
  erb :"index.html", locals: {data: data}
end

post '/update' do
  request.body.rewind
  item_data = JSON.parse(request.body.read)
  allowed_fields = ["stock", "return_value", "max_drawdown", "first_date", "last_date"]
  item = Hash[allowed_fields.map {|k| [k, item_data[k]]}]
  item["timestamp"] = Time.now.strftime("%d/%m/%Y %H:%M:%S")
  # Some input validation would be a good idea here.
  data.prepend(item)
  data.pop() if data.length > MAX_ITEMS
  save_data(data)
  status 201
end

private

def save_data(data)
  File.write(DATA_FILE, JSON.dump(data))
end
