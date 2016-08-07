class Api::GoalTimelineSerializer < Api::GoalSessionSerializer
  attributes :sessions_history, :creator

  def creator
    object.creator.serialize
  end

  def sessions_history
    object.sessions_history.map{|item| item.serialize(Api::SessionHistorySerializer) }
  end
  
end
