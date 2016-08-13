class GoalServices::SessionsHistoryForHomeTimelineBuilder
  
  TIMELINE_SESSIONS_LIMITTED = 5

  def initialize(goal_session)
    @goal_session = goal_session
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
    @sessions_history ||= GoalSession.same_goal_for(@goal_session).limit(TIMELINE_SESSIONS_LIMITTED).to_a.reverse
  end

  def date_labels
    current_date = Time.current.beginning_of_day
    current_session_created_at = @goal_session.created_at.beginning_of_day
    sessions_history.map do |session|
      created_at = session.created_at.beginning_of_day
      date_info = session.created_at.strftime("%d %b")
  
      if created_at == current_date
        date_info = "Today"
      # elsif created_at == current_date - 1.day
      #   date_info = "Yesterday"
      end

      marked = session.id == @goal_session.id ? '✓' : nil
      [date_info, marked].compact.join
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
