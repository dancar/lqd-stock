require 'oauth'

class TwitterPublisher
  STATUS_UPDATE_ENDPOINT = "https://api.twitter.com/1.1/statuses/update.json"

  def initialize
    @settings = Settings[:publishers][:twitter]
  end

  def publish(info)
    status = tweet(info.to_s)
    if status == :success
      puts "Tweet published in: http://twitter.com/%s" % @settings[:handle]
    else
      puts("Error twitting using account: %s " % @settings[:handle])
    end
  end

  def tweet(tweet)
    consumer = OAuth::Consumer.new(
      @settings[:api_key],
      @settings[:api_secret],
      {
        site: "https://api.twitter.com",
        scheme: :header
      })

    token_hash = {
      oauth_token: @settings[:oauth_token_key],
      oauth_token_secret: @settings[:oauth_token_secret],
    }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    response = access_token.request(:post, STATUS_UPDATE_ENDPOINT, {status: tweet})

    response.kind_of?(Net::HTTPSuccess) ? :success : :error
  end
end
