class Api::GoalTimelineSerializer < Api::GoalSessionSerializer
  attributes :sessions_history

  def sessions_history
    object.sessions_history.map{|item| item.serialize(Api::SessionHistorySerializer) }
  end

  def goal
    object.goal.serialize
  end
  
end
