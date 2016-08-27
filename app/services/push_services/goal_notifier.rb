class PushServices::GoalNotifier

  def initialize(current_user, goal)
    @current_user = current_user
    @goal = goal
  end

  def notify_challenge_to(user)
    notifier.push(
      message: challenge_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:challenge_sent],
      goal_id: @goal.id
    )
  end

  def notify_challenge_accepted_to(user)
    notifier.push(
      message: accept_challenge_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:challenge_accepted],
      goal_id: @goal.id
    )
  end

  def notify_like_to(user)
    notifier.push(
      message: like_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:like_goal],
      goal_id: @goal.id
    )
  end

  def notify_comment_to(user)
    notifier.push(
      message: comment_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:comment_on_goal],
      goal_id: @goal.id
    )
  end

  def notify_like_comment_to(user, on_comment)
    notifier.push(
      message: like_comment_message, 
      tag: user.airship_tag, 
      event_type: PushServices::Notifier::EVENT_TYPES[:like_comment],
      comment_id: on_comment.id,
      goal_id: @goal.id
    )
  end

  private

  def notifier
    @notifier ||= PushServices::Notifier.new
  end

  def like_message
    [ @current_user.display_name, "liked your goal:", @goal.detail_name ].join(" ")
  end

  def challenge_message
    [ @current_user.display_name, "want to challenge you:", @goal.detail_name ].join(" ")
  end

  def accept_challenge_message
    [ @current_user.display_name, "join", "your", "challenge:", @goal.detail_name ].join(" ")
  end

  def comment_message
    [ @current_user.display_name, "just comment on", "your", "goal:", @goal.detail_name ].join(" ")
  end

  def like_comment_message
    [ @current_user.display_name, "just like your comment." ].join(" ")
  end

end
