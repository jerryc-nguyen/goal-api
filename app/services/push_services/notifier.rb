class PushServices::Notifier

  EVENT_TYPES = {
    friend_requested: "friend_requested",
    friend_accepted: "friend_accepted",
    challenge_sent: "challenge_sent",
    challenge_accepted: "challenge_accepted",
    like_goal: "like_goal",
    comment_on_goal: "comment_on_goal",
    like_comment: "like_comment"
  }

  def initialize(push_client = nil)
    @push_client = push_client || airship_client
  end

  def push(message: "Hello from Goal API Backend", tag: nil, event_type: nil)
    audience = tag.present? ? Urbanairship.tag(tag) : Urbanairship.all
    airship_push_instance.audience = audience
    airship_push_instance.notification = Urbanairship.notification(
      alert: message, 
      ios: ios_params_for(message, event_type)
    )
    airship_push_instance.send_push
  end

  private

  def ios_params_for(message, event_type)
    Urbanairship.ios(
      sound: "default",
      alert: message,
      extra: { event_type: event_type }
    )
  end

  def airship_client
    @airship_client ||= Urbanairship::Client.new(key: Settings.push_notification.app_id, secret: Settings.push_notification.app_master_secret)
  end

  def airship_push_instance
    @airship_push_instance ||= begin
      p = airship_client.create_push
      p.device_types = Urbanairship.all
      p
    end
  end

end
