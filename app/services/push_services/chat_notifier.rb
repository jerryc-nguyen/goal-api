class PushServices::ChatNotifier

  def initialize(current_user, chat, to_user)
    @current_user = current_user
    @chat = chat
    @to_user = to_user
  end

  def process
    return unless @chat.present?

    if @chat.goal.present?
      notify_buddies_chat
    else
      notify_direct_chat
    end
  end

  def notify_buddies_chat
    notifier.push(
      message: group_message, 
      tag: @to_user.airship_tag, 
      extra_data: {
        event_type: PushServices::Notifier::EVENT_TYPES[:group_message]
      }
    )
  end

  def notify_direct_chat
    notifier.push(
      message: direct_message, 
      tag: @to_user.airship_tag, 
      extra_data: {
        event_type: PushServices::Notifier::EVENT_TYPES[:direct_message]
      }
    )
  end

  private

  def notifier
    @notifier ||= PushServices::Notifier.new
  end

  def group_message
    [ @current_user.display_name, "send to", goal_name, "message:", @chat.message.to_s ].join(" ")
  end

  def direct_message
    [ @current_user.display_name, "send you a message:", @chat.message.to_s ].join(" ")
  end

  def goal_name
    @chat.goal.detail_name.to_s rescue "buddies chat"
  end

end
