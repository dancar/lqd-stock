require 'oauth'

class TwitterPublisher
  STATUS_UPDATE_ENDPOINT = "https://api.twitter.com/1.1/statuses/update.json"
  TWEET_TEMPLATE = <<~TEMPLATE
    Stock Update: %{stock}
    Rate of Return: %{return_rate}
    Max Drawdown: %{max_drawdown}
  TEMPLATE

  def initialize
    @settings = Settings.new()[:publishers][:twitter]
  end

  def publish(info)
    tweet(TWEET_TEMPLATE % info)
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
    access_token.request(:post, STATUS_UPDATE_ENDPOINT, {status: tweet})
    # TODO: handle errors?
  end
end
