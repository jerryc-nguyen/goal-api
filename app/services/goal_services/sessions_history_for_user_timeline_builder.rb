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
    Goal.previous_dates_labels_for_single_goal.each_with_index.map do |value, index|
      date_at_index = Goal.previous_dates_for_single_goal[index]
      date_score_mapped[date_at_index].present? ? value : ""
      value
    end
  end

  def scores
    Goal.previous_dates_for_single_goal.map do |date|
      date_score_mapped[date] || -1
    end
  end

  def date_score_mapped
    @date_score_mapped ||= begin 
      score_seed = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
      date_score = {}
      sessions_history.each do |session|
        value = score_seed.shuffle.first
        date = session.created_at.beginning_of_day.to_i
        date_score[date] = session.score
      end
      date_score
    end
  end

  def session_ids
    sessions_history.map do |session|
      session.id
    end
  end

end
