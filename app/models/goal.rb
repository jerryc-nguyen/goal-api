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
    goal_sessions.create(participant_id: user.id, is_accepted: is_accepted)
  end

  def invite_participant_for(user)
    add_participant_for(user, false)
  end

end
