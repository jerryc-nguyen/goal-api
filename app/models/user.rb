class User < ActiveRecord::Base
  acts_as_paranoid
  include Amistad::FriendModel

  has_many :goals
  has_many :goal_sessions, foreign_key: :participant_id
  has_many :comments, foreign_key: :creator_id
  has_many :likes, foreign_key: :creator_id
  has_many :notifications
  
end
