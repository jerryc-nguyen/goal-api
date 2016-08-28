class Api::GoalSessionSerializer < ActiveModel::Serializer
  attributes :id, :creator_id, :goal_id, :participant_id, :score, 
    :is_accepted, :views_count, 
    :goal_name, :finish_sentence, :feeling_sentence, :created_at,
    :status, :user_start_at, :remind_user_at, :user_completed_at, :goal
    
  def goal
    return nil unless object.goal
    object.goal.serialize
  end

end
