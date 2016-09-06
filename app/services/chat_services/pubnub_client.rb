module ChatServices
  class PubnubClient
    include Singleton

    def initialize
      @pubnub = Pubnub.new(
        subscribe_key: Settings.pubnub.sub_key,
        publish_key: Settings.pubnub.pub_key
      )
    end

    def publish(channel, message)
      params = {
        http_sync: true,
        channel: channel, 
        message: message
      }
      @pubnub.publish(params)
    end

  end

end 

