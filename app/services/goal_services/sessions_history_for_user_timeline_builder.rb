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
    score_seed = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    date_score = {}
    sessions_history.each do |session|
      value = score_seed.shuffle.first
      date = session.created_at.beginning_of_day.to_i
      date_score[date] = session.score
    end
      
    Goal.previous_dates_for(@viewing_user).map do |date|
      date_score[date] || -1
    end
  end

  def session_ids
    sessions_history.map do |session|
      session.id
    end
  end

end
