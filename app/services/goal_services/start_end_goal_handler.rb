class GoalServices::StartEndGoalHandler
  attr_reader :error_message, :goal_session

  def initialize(current_user, goal, params)
    @current_user = current_user
    @goal = goal
    @session_status = params[:status]
    @session_params = params
  end

  def handle_success?
    unless GoalSession.statuses.keys.include?(@session_status)
      @error_message = "Invalid goal session status value."
      return false
    end

    handle_update_session
  end

  def error_message
    @error_message ||= @goal_session.errors.full_messages.to_sentence
  end

  private

  def handle_update_session
    case @session_status
    when "doing"
      @goal_session = find_or_initialize_session_todo_today
      @goal_session.status = @session_status
      @goal_session.user_start_at = Time.current
    when "completed"
      @goal_session = find_or_initialize_session_to_complete_today
      @goal_session.status = @session_status
      @goal_session.user_completed_at = Time.current
      @goal_session.score = @session_params[:score]
      if @goal_session.user_start_at.blank?
        @goal_session.user_start_at = @goal_session.user_completed_at
      end
    when "remind_later"
      @goal_session = find_or_initialize_session_todo_today
      @goal_session.status = @session_status
      @goal_session.remind_user_at = @session_params[:remind_user_at]
    when "cannot_make_today"
      @goal_session = find_or_initialize_session_todo_today
      @goal_session.status = @session_status
      @goal_session.user_completed_at = Time.current
      @goal_session.score = 0
    else
      raise "#{@session_status} not implemented!"
    end
    @goal_session.save
  end

  def find_or_initialize_session_todo_today
    GoalSession.sessions_todo_today_for(@goal, @current_user).first || session_todo_created_today
  end

  def session_todo_created_today
    session = GoalSession.sessions_todo_or_doing_created_today_for(@goal, @current_user).first
    session || @goal.goal_sessions.new(creator_id: @goal.creator_id, participant_id: @current_user.id, is_accepted: true)
  end

  def find_or_initialize_session_to_complete_today
    GoalSession.sessions_to_complete_today_for(@goal, @current_user).first || session_to_complete_created_today
  end

  def session_to_complete_created_today
    session = GoalSession.sessions_to_complete_or_completed_created_today_for(@goal, @current_user).first
    session || @goal.goal_sessions.new(creator_id: @goal.creator_id, participant_id: @current_user.id, is_accepted: true)
  end

end
