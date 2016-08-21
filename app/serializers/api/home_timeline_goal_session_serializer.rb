class Api::HomeTimelineGoalSessionSerializer < Api::GoalSessionSerializer
  attributes :sessions_history, :participant

  def participant
    object.participant.serialize
  end

  def sessions_history
    GoalServices::SessionsHistoryForHomeTimelineBuilder.new(object).build
  end
  
end
