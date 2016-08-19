class Api::GoalsController < ApiController
  before_action :authenticate!
  before_action :find_goal, only: [ :show, :update, :destroy]
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
