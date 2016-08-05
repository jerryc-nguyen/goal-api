class Api::GoalSessionSerializer < ActiveModel::Serializer
  attributes :id, :creator_id, :goal_id, :participant_id, :score, :is_accepted, :likes_count, :comments_count, :views_count, :goal

  def goal
    object.goal.serialize
  end
  
end
