class Api::GoalSessionsController < ApiController
  before_action :authenticate!
  before_action :find_goal_session, only: [ :show, :update, :destroy, :invite ]
  before_action :validate_friend_id!, only: [ :invite ]
  
  def index
    success(data: current_user.goal_sessions)
  end

  def show
    success(data: @goal_session)
  end

  def create
    goal_session = GoalSession.create(goal_session_params)
    if goal_session.valid?
      success(data: goal_session)
    else
      error(message: goal_session.errors.full_messages.to_sentence)
    end
  end

  def update
    if @goal_session.update(goal_session_params)
      success(data: @goal_session)
    else
      error(message: @goal_session.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @goal_session.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @goal_session.errors.full_messages.to_sentence)
    end
  end

  def invite
    goal_session = @goal_session.invite_participant_for(@friend)
    if goal_session.valid?
      success(data: { message: "Invitation sent to #{@friend.display_name}" })
    else
      error(message: goal_session.errors.full_messages.to_sentence)
    end
  end

  def pending_accept
    goal_sessions = GoalSession.pending_accept_to_join_goal_for(current_user)
    success(data: goal_sessions)
  end

  def accept
    current_pending_goal_sessions = GoalSession.pending_accept_to_join_goal_for(current_user)
    goal_session = current_pending_goal_sessions.find_by_id(params[:id])
    return error(message: "You does not have any request to join this goal.") if goal_session.blank?

    goal_session.is_accepted = true
    if goal_session.save
      success(data: "Accepted to join goal: #{goal_session.goal_detail_name}")
    else
      error(message: "Fail to join goal: #{goal_session.goal_detail_name}")
    end
  end

  private

  def find_goal_session
    @goal_session ||= GoalSession.find(params[:id])
  end

  def goal_session_params
    @goal_session_params ||= params.require(:goal_session).permit(*Settings.params_permitted.goal_session)
  end

end
