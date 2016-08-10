class Api::GoalTimelineSerializer < Api::GoalSessionSerializer
  attributes :sessions_history, :participant

  def participant
    object.participant.serialize
  end

  def sessions_history
    GoalServices::SessionsHistoryBuilder.new(object).build
  end
  
end
