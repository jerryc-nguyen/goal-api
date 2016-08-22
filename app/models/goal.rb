class Goal < ActiveRecord::Base
  include Serializeable
  
  DEFAULT_SERIALIZER = Api::GoalSerializer
  
  DAYS_PREVIOUS  = 7
  DAYS_PREVIOUS_SINGLE_GOAL = 8

  belongs_to  :creator, class_name: "User"
  belongs_to  :category
  has_many    :goal_sessions, dependent: :destroy
  enum        status: { enabled: 0, disabled: 1 }
  enum        sound_name: { clock_alarm: 0 }

  scope :joined_by, -> (user) {
    session_sql = GoalSession.joined_by(user)
      .select("goal_sessions.goal_id, max(goal_sessions.created_at) as max_session_completed_at")
      .group("goal_sessions.goal_id").to_sql

    joins("JOIN (#{session_sql}) as recent_goals ON recent_goals.goal_id = goals.id")
    .order("max_session_completed_at desc")
  }
  
  scope :for_session_ids, -> (sessions) {
    where(id: ids)
  }

  validates :category_id, presence: true
  validates :start_at, presence: true
  validates :sound_name, presence: true
  validates :duration, :numericality => { :greater_than => 0 }
  
  validate :validate_repeat_every #validate repeat_every in ["monday", "tuesday", ...]
  validate :validate_goal_settings, on: [ :create ]

  delegate :selected_color, to: :category, prefix: true, allow_nil: true

  def start_at_hour
    start_at.hour rescue 0
  end

  def start_at_minute
    start_at.min rescue 0
  end

  def start_at_second
    start_at.sec rescue 0
  end

  def start_at_interval
    (start_at.hour * 60 + start_at.min) * 60 rescue 0
  end

  def session_end_at
    start_at + 60*duration.to_i
  end

  def end_at_hour
    session_end_at.hour rescue 0
  end

  def end_at_minute
    session_end_at.min rescue 0
  end

  def end_at_second
    session_end_at.sec rescue 0
  end

  def start_at_interval
    (start_at.hour * 60 + start_at.min) * 60 rescue 0
  end

  def end_at_interval
    start_at_interval + duration.to_i * 60 rescue 0
  end

  def self.min_date_completed_session_for(user)
    GoalSession.joined_by(user).minimum(:created_at)
  end

  def self.max_date_completed_session_for(user)
    GoalSession.joined_by(user).maximum(:created_at)
  end

  def add_participant_for(user, is_accepted = true)
    goal_sessions.create(participant_id: user.id, is_accepted: is_accepted, creator_id: creator_id)
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
  
  def formatted_start_at
    start_at.present? ? start_at.strftime("%H:%M") : created_at.strftime("%H:%M")
  end

  def detail_name
    [category.name, "at", formatted_start_at].join(" ")
  end

  def self.previous_dates_for(user)
    total_days = Goal.max_date_completed_session_for(user) - Goal.min_date_completed_session_for(user)
    total_days = (total_days / 84000).to_i - 1
    if total_days > DAYS_PREVIOUS
      @previous_dates ||= begin
        (0..DAYS_PREVIOUS).to_a.reverse.map.each do |value|
          (Time.current - value.day).beginning_of_day.to_i
        end
      end
    else
      @previous_dates ||= begin
        (0..total_days).to_a.reverse.map.each do |value|
          (Goal.max_date_completed_session_for(user) - value.day).beginning_of_day.to_i
        end
      end
    end
  end

  def self.previous_date_labels_for(user)
    total_days = Goal.max_date_completed_session_for(user) - Goal.min_date_completed_session_for(user)
    total_days = (total_days / 84000).to_i - 1
    if total_days > DAYS_PREVIOUS
      @previous_date_labels ||= begin
        (0..DAYS_PREVIOUS).to_a.reverse.map.each do |value|
          (Time.current - value.day).strftime("%d %m")
        end
      end
    else
      @previous_date_labels ||= begin
        (0..total_days).to_a.reverse.map.each do |value|
          (Goal.max_date_completed_session_for(user) - value.day).strftime("%d-%m")
        end
      end
    end
  end

  def self.previous_dates_for_single_goal
    @previous_dates_for_single_goal ||= begin
      (0..DAYS_PREVIOUS_SINGLE_GOAL).to_a.reverse.map.each do |value|
        (Time.current - value.day).beginning_of_day.to_i
      end
    end
  end

  def self.previous_dates_labels_for_single_goal
    @previous_dates_labels_for_single_goal ||= begin
      (0..DAYS_PREVIOUS_SINGLE_GOAL).to_a.reverse.map.each do |value|
        if value == 0 
          "Today"
        else
          (Time.current - value.day).strftime("%a")
        end
      end
    end
  end

  #swim: 23: [0, 2, 4, 6]
  #run: 24 : [0, 1, 5]
  #mediate: 25 [1, 3, 4, 7]
  def add_fake_sessions_for(user, date_minus_arr = [])
    raise "#{user.display_name} does not participate to this goal!" unless user.participate_to?(self)
    scores = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    
    date_minus_arr.each do |day_ago|
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

  def validate_goal_settings
    if Goal.exists?(category_id: category_id, start_at: start_at, creator_id: creator_id)
      errors.add(" ", "You already setted goal: #{detail_name}")
    end
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
