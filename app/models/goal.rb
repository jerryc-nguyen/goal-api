class Goal < ActiveRecord::Base
  include Serializeable
  
  DEFAULT_SERIALIZER = Api::GoalSerializer

  belongs_to  :creator, class_name: "User"
  belongs_to  :category
  has_many    :goal_sessions
  enum        status: { enabled: 0, disabled: 1 }

  scope :for_session_ids, -> (sessions) {
    where(id: ids)
  }

  validates :category_id, presence: true

  def add_participant_for(user, is_accepted = true)
    goal_sessions.create!(participant_id: user.id, is_accepted: is_accepted, creator_id: creator_id)
  end

  def invite_participant_for(user)
    add_participant_for(user, false)
  end

  def formatted_start_at
    start_at.present? ? start_at.strftime("%H:%M") : created_at.strftime("%H:%M")
  end

  private

  before_create do
    generate_goal_name
    set_default_start_time
  end

  def generate_goal_name
    self.name = [category.name, "at", formatted_start_at].join(" ")
  end

  def set_default_start_time
    self.start_at ||= DateTime.now.in_time_zone(Time.zone).beginning_of_day + 6*3600
  end

end
