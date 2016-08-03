class Api::GoalSessionSerializer < ActiveModel::Serializer
  attributes :id, :creator_id, :goal_id, :goal

  def goal
    object.goal.serialize
  end
  
end
