class PushServices::FriendshipNotifier

  def initialize(current_user)
    @current_user = current_user
  end

  def notify_request_to(user)
    notifier.push(
      message: request_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:friend_requested]
    )
  end

  def notify_accept_to(user)
    notifier.push(
      message: accept_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:friend_accepted]
    )
  end

  private

  def notifier
    @notifier ||= PushServices::Notifier.new
  end

  def request_message
    [ @current_user.display_name, "want to be your friend." ].join(" ")
  end

  def accept_message
    [ @current_user.display_name, "accepted your friend request." ].join(" ")
  end

end
