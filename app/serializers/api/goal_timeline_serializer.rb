class Api::GoalTimelineSerializer < Api::GoalSessionSerializer
  attributes :sessions_history, :participant

  def participant
    object.participant.serialize
  end

  def sessions_history
    object.sessions_history.map{|item| item.serialize(Api::SessionHistorySerializer) }
  end
  
end
