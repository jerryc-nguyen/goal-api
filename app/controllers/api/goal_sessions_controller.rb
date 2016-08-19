class Api::GoalSessionsController < ApiController
  before_action :authenticate!
  before_action :find_goal_session, only: [ :show, :update, :destroy ]

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

  private

  def find_goal_session
    @goal_session ||= GoalSession.find(params[:id])
  end

  def goal_session_params
    @goal_session_params ||= params.require(:goal_session).permit(*Settings.params_permitted.goal_session)
  end

end
