class Api::GoalsController < ApiController
  before_action :authentication!
  before_action :find_goal, only: [ :show, :update, :destroy ]

  def index
    success(data: current_user.goals)
  end

  def show
    success(data: @goal)
  end

  def create
    goal = current_user.goals.create(goal_params)
    if goal.valid?
      success(data: goal)
    else
      error(message: goal.full_messages.to_sentence)
    end
  end

  def update
    if @goal.update(goal_params)
      success(data: @goal)
    else
      error(message: @goal.full_messages.to_sentence)
    end
  end

  def destroy
    if @goal.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @goal.full_messages.to_sentence)
    end
  end

  private

  def find_goal
    @goal ||= current_user.goals.find(params[:id])
  end

  def goal_params
    @goal_params ||= params.require(:goal).permit(*Settings.params_permitted.goal)
  end

end
