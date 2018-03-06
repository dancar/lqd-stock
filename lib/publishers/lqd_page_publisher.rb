require 'net/http'
require 'uri'
require 'json'

class LqdPagePublisher
  def initialize
    @settings = Settings[:publishers][:lqd_page]
  end

  def publish(info)
    page = @settings[:url]
    uri = URI.parse(page + "/update")
    http = Net::HTTP.new(uri.host, uri.port)
    header = {'Content-Type': 'text/json'}
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = info.to_json
    response = http.request(request)
    if !response.kind_of? Net::HTTPSuccess
      puts "Error publishing in LqD-Page: %s\n%s" % [uri, response.to_s]
    else
      puts "Stock Info publlished in %s" % page
    end
    response
  end
end
