class Api::HomeTimelineSerializer < ActiveModel::Serializer
  attributes :goal_session

  def goal_session
    if object.class.name == "GoalSession"
      Api::HomeTimelineGoalSessionSerializer.new(object, { current_user: viewing_user }).attributes
    end
  end

  def viewing_user
    @viewing_user ||= @instance_options[:current_user]
  end

end
