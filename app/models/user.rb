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
  
  def friendship_with(friend)
    friendships.find_by(friend_id: friend.id)
  end

  def avatar_url
    JSON.parse(auth_picture).fetch("data", {}).fetch("url", Settings.default_avatar) rescue Settings.default_avatar
  end

  private

  before_create do 
    self.token = generate_token
  end

  def generate_token
    loop do
      token = SecureRandom.hex(16)
      break token unless User.exists?(token: token)
    end
  end

end
