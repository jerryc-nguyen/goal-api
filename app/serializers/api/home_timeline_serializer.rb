class Api::HomeTimelineSerializer < ActiveModel::Serializer
  attributes :goal_session

  def goal_session
    if object.class.name == "GoalSession"
      Api::HomeTimelineGoalSessionSerializer.new(object).attributes
    end
  end
end
