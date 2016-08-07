class GoalSession < ActiveRecord::Base
  paginates_per 5

  include Serializeable
  include Notificable
  include Likeable
  include Commentable
  # include PublicActivity::Model
  # tracked

  DEFAULT_SERIALIZER = Api::GoalSessionSerializer

  #validates_uniqueness_of :participant_id, scope: [:goal_id ] => validate user can not set session same time!

  validates :creator_id, presence: true

  belongs_to :creator, class_name: "User"
  belongs_to :participant, class_name: "User"
  belongs_to :goal
  
  delegate :name, to: :goal, prefix: true, allow_nil: true

  scope :pending_accepted_for, -> (user) {
    where(is_accepted: false, participant_id: user.id)
  }

  scope :sessions_history_for, -> (goal_session) {
    where(creator: goal_session.creator_id, goal: goal_session.goal_id)
  }

  def sessions_history
    GoalSession.sessions_history_for(self)
  end

  def finish_sentence
    ["Just finish", "my", self.goal_name , "goal!"].join(" ")
  end
  
  def feeling_sentence
    ["feel", "amazing!"].join(" ")
  end

end
