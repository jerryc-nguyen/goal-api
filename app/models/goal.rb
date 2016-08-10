class Goal < ActiveRecord::Base
  include Serializeable
  
  DEFAULT_SERIALIZER = Api::GoalSerializer

  belongs_to  :creator, class_name: "User"
  belongs_to  :category
  has_many    :goal_sessions
  enum        status: { enabled: 0, disabled: 1 }
  enum        sound_name: { clock_alarm: 0 }
  
  scope :for_session_ids, -> (sessions) {
    where(id: ids)
  }

  validates :category_id, presence: true
  validate :validate_repeat_every #validate repeat_every in ["monday", "tuesday", ...]

  def add_participant_for(user, is_accepted = true)
    goal_sessions.create!(participant_id: user.id, is_accepted: is_accepted, creator_id: creator_id)
  end

  def completed_session_for(user, score, created_at = nil, feeling = nil)
    params = {
      participant_id: user.id, 
      is_accepted: true, 
      creator_id: creator_id, 
      score: score
    }
    params[:created_at] = created_at if created_at.present?
    goal_sessions.create(params)
  end

  def invite_participant_for(user)
    add_participant_for(user, false)
  end

  def formatted_start_at
    start_at.present? ? start_at.strftime("%H:%M") : created_at.strftime("%H:%M")
  end

  def detail_name
    [category.name, "at", formatted_start_at].join(" ")
  end

  def add_fake_sessions_for(user)
    raise "#{user.display_name} does not participate to this goal!" unless user.participate_to?(self)
    scores = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    [0,1,2,3,4,5,6, 7].each do |day_ago|
      date = Time.current - day_ago.day
      
      unless user.participate_on?(self, date) #check if user not participate to this goal on date
        score = scores.shuffle.first
        completed_session_for(user, score, date)
      end

    end
  end

  private

  before_create do
    generate_goal_name
    set_default_start_time
  end

  def validate_repeat_every
    values = repeat_every.is_a?(Array) ? repeat_every : []
    if repeat_every.any?
      invalid_values = values - Settings.goals.repeat_every
      if invalid_values.any?
        errors.add(:repeat_every, "has invalid values: #{invalid_values.join(', ')}")
      end
    else
      errors.add(:repeat_every, "must be an array of values.")
    end
  end

  def generate_goal_name
    self.name = category.name
  end

  def set_default_start_time
    self.start_at ||= Time.current.in_time_zone(Time.zone).beginning_of_day + 6*3600
  end

end
