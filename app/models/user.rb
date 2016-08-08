class User < ActiveRecord::Base
  acts_as_paranoid
  
  include Serializeable
  include Amistad::FriendModel

  DEFAULT_SERIALIZER = Api::UserSerializer
  
  enum auth_system: { email_or_phone: 0, facebook: 1, twitter: 2 }

  has_many :goals, foreign_key: :creator_id
  has_many :goal_sessions, foreign_key: :participant_id
  has_many :comments, foreign_key: :creator_id
  has_many :likes, foreign_key: :creator_id
  has_many :notifications

  has_many :categories

  def friendship_with(friend)
    friendships.find_by(friend_id: friend.id)
  end

  def participate_to(goal)
    goal.goal_sessions.create(participant_id: self.id)
  end

  def participate_to?(goal)
    goal.goal_sessions.exists?(participant_id: self.id, is_accepted: true)
  end

  def participate_on?(goal, date)
    goal.goal_sessions.exists?(created_at: date.beginning_of_day..date.end_of_day, goal_id: goal.id, participant_id: self.id) 
  end

  def avatar_url
    JSON.parse(auth_picture).fetch("data", {}).fetch("url", Settings.default_avatar) rescue Settings.default_avatar
  end

  def display_name
    auth_name || "#{first_name} #{last_name}"
  end
  
  private

  before_create do 
    self.token = generate_token
  end

  after_create do
    initialize_users_data
  end

  def generate_token
    loop do
      token = SecureRandom.hex(16)
      break token unless User.exists?(token: token)
    end
  end

  def initialize_users_data
    create_default_categories
  end

  def create_default_categories
    Category.transaction do
      Settings.default_goal_categories.each_with_index do |cat_name, index|
        category = categories.find_or_initialize_by(name: cat_name)
        category.is_default = true
        category.nth = index
        category.save
      end
    end
  end

end
