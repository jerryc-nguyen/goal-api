class Api::GoalUserTimelineSerializer < Api::GoalSerializer
  attributes :sessions_history, :buddies_count, :is_liked

  def sessions_history
    GoalServices::SessionsHistoryForUserTimelineBuilder.new(object, viewing_user).build
  end
  
  def is_liked
    return false unless viewing_user.present?
    object.likes.exists?(creator_id: viewing_user.id)
  end

  def viewing_user
    @viewing_user ||= @instance_options[:current_user]
  end
  
  def buddies_count
    return 2 if [87].include?(object.id)
    object.goal_sessions.pluck(:participant_id).uniq.count
  end
end
