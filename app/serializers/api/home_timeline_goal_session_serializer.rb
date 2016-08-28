class Api::HomeTimelineGoalSessionSerializer < Api::GoalSessionSerializer
  attributes :sessions_history, :participant, :is_liked

  def participant
    object.participant.serialize
  end

  def is_liked
    return false unless viewing_user.present?
    object.goal.likes.exists?(creator_id: viewing_user.id)
  end

  def sessions_history
    GoalServices::SessionsHistoryForHomeTimelineBuilder.new(object).build
  end
  
  def viewing_user
    @viewing_user ||= @instance_options[:current_user]
  end

end
