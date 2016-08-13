class GoalServices::SessionsHistoryForUserTimelineBuilder
  
  def initialize(goal, viewing_user)
    @goal = goal
    @viewing_user = viewing_user
  end

  def build
    {
      date_labels: date_labels,
      scores: scores,
      # current_id: @goal_session.id,
      # session_ids: session_ids
    }
  end

  private

  def sessions_history
    @sessions_history ||= GoalSession.sessions_history_of(@goal, @viewing_user)
  end

  def date_labels
    sessions_history.map do |session|
      date_info = session.created_at.strftime("%d %b")
    end
  end

  def scores
    sessions_history.map do |session|
      session.score * 1.0
    end
  end

  def session_ids
    sessions_history.map do |session|
      session.id
    end
  end

end
