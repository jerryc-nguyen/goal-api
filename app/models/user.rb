class User < ActiveRecord::Base
  acts_as_paranoid
  include Amistad::FriendModel

  DEFAULT_SERIALIZER = Api::UserSerializer
  
  enum auth_system: { email_or_phone: 0, facebook: 1, twitter: 2 }

  has_many :goals, foreign_key: :creator_id
  has_many :goal_sessions, foreign_key: :participant_id
  has_many :comments, foreign_key: :creator_id
  has_many :likes, foreign_key: :creator_id
  has_many :notifications
  
end
