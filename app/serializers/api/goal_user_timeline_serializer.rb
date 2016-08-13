class Api::GoalUserTimelineSerializer < Api::GoalSerializer
  attributes :sessions_history

  def sessions_history
    GoalServices::SessionsHistoryForUserTimelineBuilder.new(object, viewing_user).build
  end
    
  def viewing_user
    @viewing_user ||= @instance_options[:current_user]
  end
end
