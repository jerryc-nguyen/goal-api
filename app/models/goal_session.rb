class GoalSession < ActiveRecord::Base
  paginates_per 5

  include Serializeable
  # include Notificable
  include Likeable
  include Commentable
  # include PublicActivity::Model
  # tracked

  DEFAULT_SERIALIZER = Api::GoalSessionSerializer

  WEEK_DAYS = {
    0 => "sunday",
    1 => "monday",
    2 => "tuesday",
    3 => "wednesday",
    4 => "thursday",
    5 => "friday",
    6 => "saturday"
  }

  #validates_uniqueness_of :participant_id, scope: [:goal_id ], message: 'You have joined this goal.' #user only can participate to goal 1 time.

  validates :creator_id, presence: true

  belongs_to :creator, class_name: "User"
  belongs_to :participant, class_name: "User"
  belongs_to :goal
  
  WAITING_TO_DO = 0
  DOING = 1
  COMPLETED = 2
  REMIND_LATER = 3
  CANNOT_MAKE_TODAY = 4

  enum status: { waiting_to_do: WAITING_TO_DO, doing: DOING, completed: COMPLETED, remind_later: REMIND_LATER, cannot_make_today: CANNOT_MAKE_TODAY }

  delegate :name,         to: :goal, prefix: true, allow_nil: true
  delegate :detail_name,  to: :goal, prefix: true, allow_nil: true

  scope :pending_accept_to_join_goal_for, -> (user) {
    user.goal_sessions.where(is_accepted: false)
  }

  scope :joined_by, -> (user) {
    user.goal_sessions.where(is_accepted: true)
  }

  scope :same_goal_for, -> (goal_session) {
    where(creator: goal_session.creator_id, goal: goal_session.goal_id)
  }

  scope :sessions_history_of, -> (goal, viewing_user) {
    where(creator: goal.creator_id, participant_id: viewing_user.id, is_accepted: true, goal_id: goal.id).order(created_at: :asc)
  }

  scope :created_today, -> {
    where("created_at >= ? AND created_at <= ?", Time.current.beginning_of_day, Time.current.end_of_day)
  }

  scope :session_today_for, -> (goal, participant) {
    goal_session_wday = WEEK_DAYS[Time.current.wday]
    joins(:goal)
      .where(goal_id: goal.id, participant_id: participant.id)
      .where("goals.repeat_every @> ?", "{#{goal_session_wday}}")
  }

  scope :sessions_todo_today_for, -> (goal, participant) {
    session_today_for(goal, participant).waiting_to_do
  }

  scope :sessions_to_complete_today_for, -> (goal, participant) {
    session_today_for(goal, participant).doing
  }

  scope :sessions_created_today_for, -> (goal, participant) {
    goal.goal_sessions.where(participant_id: participant.id).created_today
  }

  scope :sessions_todo_or_doing_created_today_for, ->(goal, participant) {
    sessions_created_today_for(goal, participant).where(status: [WAITING_TO_DO, DOING])
  }

  scope :sessions_to_complete_or_completed_created_today_for, ->(goal, participant) {
    sessions_created_today_for(goal, participant).where(status: [DOING, COMPLETED])
  }

  def invite_participant_for(user)
    goal.add_participant_for(user, false)
  end

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
