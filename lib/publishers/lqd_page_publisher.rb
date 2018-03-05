require 'net/http'
require 'uri'
require 'json'

class LqdPagePublisher
  def initialize
    @settings = Settings.new()[:publishers][:lqd_page]
  end

  def publish(info)
    uri = URI.parse(@settings[:url])
    http = Net::HTTP.new(uri.host, uri.port)
    header = {'Content-Type': 'text/json'}
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = info.to_json
    response = http.request(request)
    response
  end
end
