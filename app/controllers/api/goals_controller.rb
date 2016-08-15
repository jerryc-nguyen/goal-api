class Api::GoalsController < ApiController
  before_action :authenticate!
  before_action :find_goal, only: [ :show, :update, :destroy, :invite]
  before_action :validate_friend_id!, only: [ :invite ]
  before_action :validate_goal_owner, only: [ :update, :destroy ]

  def index
    success(data: Goal.joined_by(current_user))
  end

  def show
    success(data: @goal)
  end

  def create
    Goal.transaction do
      if (goal = current_user.goals.create(goal_params)).valid?
        if (goal_session = goal.add_participant_for(current_user)).valid?
          p goal.serialize
          success(data: goal)
        else
          error(message: goal_session.errors.full_messages.to_sentence)
          raise ActiveRecord::Rollback
        end
      else
        error(message: goal.errors.full_messages.to_sentence)
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    if @goal.update(goal_params)
      success(data: @goal)
    else
      error(message: @goal.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @goal.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @goal.errors.full_messages.to_sentence)
    end
  end

  def invite
    goal_session = @goal.invite_participant_for(@friend)
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
    goal_session = current_pending_goal_sessions.find_by_id(params[:goal_session_id])
    return error(message: "You does not have any request to join this goal.") if goal_session.blank?

    goal_session.is_accepted = true
    if goal_session.save
      success(data: "Accepted to join goal: #{goal_session.goal_detail_name}")
    else
      error(message: "Fail to join goal: #{goal_session.goal_detail_name}")
    end
  end

  private

  def validate_goal_owner
    error(message: "Only goal creator can do this.") if current_user.id != @goal.creator_id
  end

  def find_goal
    @goal ||= Goal.find(params[:id])
  end

  def goal_params
    @goal_params ||= params.require(:goal).permit(*Settings.params_permitted.goal).tap do |permitted_params| 
      permitted_params[:repeat_every] = params[:goal][:repeat_every]
    end
  end

end
