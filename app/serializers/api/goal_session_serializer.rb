class Api::GoalSessionSerializer < ActiveModel::Serializer
  attributes :id, :creator_id, :goal_id, :participant_id, :score, 
    :is_accepted, :likes_count, :comments_count, :views_count, 
    :goal_name, :finish_sentence, :feeling_sentence, :created_at,
    :status, :user_start_at, :remind_user_at, :user_completed_at


end
