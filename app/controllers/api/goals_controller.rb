class Api::GoalsController < ApiController
  before_action :authenticate!
  before_action :find_goal, only: [ :show, :update, :destroy, :invite]
  before_action :validate_friend_id!, only: [ :invite ]
  before_action :validate_goal_owner, only: [:update, :destroy]

  def index
    success(data: current_user.goals)
  end

  def show
    success(data: @goal)
  end

  def create
    Goal.transaction do
      goal = current_user.goals.create!(goal_params)
      if goal.valid? && goal.add_participant_for(current_user).valid?
        success(data: goal)
      else
        error(message: goal.errors.full_messages.to_sentence)
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
    goal_sessions = GoalSession.pending_accepted_for(User.last)
    success(data: goal_sessions)
  end

  def home_timeline
    goal_sessions = GoalSession.page(params[:page] || 1)
    success(data: goal_sessions, serializer: Api::GoalTimelineSerializer)
  end

  def user_timeline
    goal_sessions = current_user.goal_sessions.page(params[:page] || 1)
    success(data: goal_sessions, serializer: Api::GoalTimelineSerializer)
  end

  private

  def validate_goal_owner
    error(message: "You can not edit goal of others.") if current_user.id != @goal.creator_id
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
