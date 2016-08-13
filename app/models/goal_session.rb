class GoalSession < ActiveRecord::Base
  paginates_per 5

  include Serializeable
  # include Notificable
  include Likeable
  include Commentable
  # include PublicActivity::Model
  # tracked

  DEFAULT_SERIALIZER = Api::GoalSessionSerializer

  #validates_uniqueness_of :participant_id, scope: [:goal_id ], message: 'You have joined this goal.' #user only can participate to goal 1 time.

  validates :creator_id, presence: true

  belongs_to :creator, class_name: "User"
  belongs_to :participant, class_name: "User"
  belongs_to :goal
  
  enum status: { waiting_to_do: 0, doing: 1, completed: 2, remind_later: 3 }

  delegate :name,         to: :goal, prefix: true, allow_nil: true
  delegate :defail_name,  to: :goal, prefix: true, allow_nil: true

  scope :pending_accept_to_join_goal_for, -> (user) {
    where(is_accepted: false, participant_id: user.id)
  }

  scope :same_goal_for, -> (goal_session) {
    where(creator: goal_session.creator_id, goal: goal_session.goal_id)
  }

  scope :sessions_history_of, -> (goal, viewing_user) {
    where(creator: goal.creator_id, participant_id: viewing_user.id, is_accepted: true, goal_id: goal.id).order(created_at: :asc)
  }

  scope :joined_by, -> (user) {
    where(participant_id: user.id, is_accepted: true)
  }

  def sessions_history
    GoalSession.same_goal_for(self)
  end

  def finish_sentence
    ["Just finish", "my", self.goal_name , "goal!"].join(" ")
  end
  
  def feeling_sentence
    ["feel", "amazing!"].join(" ")
  end

end
