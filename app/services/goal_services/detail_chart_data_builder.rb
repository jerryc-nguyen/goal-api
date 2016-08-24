class GoalServices::DetailChartDataBuilder

  def initialize(goal)
    @goal = goal
  end

  def build
    {
      date_labels: Goal.previous_dates_labels_for_single_goal,
      sessions_histories: build_chart_data
    }
  end

  private

  def goal_buddies
    @goal_buddies ||= User.where(id: @goal.goal_sessions.pluck(:participant_id))
  end

  def build_chart_data
    goal_buddies.map do |user|
      data = {}
      data[:user] = user.serialize
      user_chart_data = GoalServices::SessionsHistoryForUserTimelineBuilder.new(@goal, user).build
      user_chart_data.delete(:date_labels)
      data.merge(user_chart_data)
    end
  end

end
