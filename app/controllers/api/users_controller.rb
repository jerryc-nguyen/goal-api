class Api::UsersController < ApiController
  before_action :find_user, only: [ :show, :update, :destroy ]

  def index
    success(data: User.all)
  end

  def show
    success(data: @user)
  end

  def create
    user = User.create(user_params)
    if user.valid?
      success(data: user)
    else
      error(message: user.errors.full_messages.to_sentence)
    end
  end

  def update
    if @user.update(user_params)
      success(data: @user)
    else
      error(message: @user.errors.full_messages.to_sentence)
    end
  end

  def destroy
    if @user.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @user.errors.full_messages.to_sentence)
    end
  end

  def home_timeline
    goal_sessions = GoalSession.page(params[:page] || 1)
    success(data: goal_sessions, serializer: Api::HomeTimelineSerializer)
  end

  def timeline
    viewing_user = User.find(params[:id])
    goals = Goal.joined_by(viewing_user)
    response_data = {
      goals: Goal.serialize_items(goals, current_user, Api::GoalUserTimelineSerializer),
      viewing_user: viewing_user.serialize,
      date_labels: Goal.previous_date_labels_for(viewing_user)
    }

    success(data: response_data)
  end

  private

  def find_user
    @user ||= User.find(params[:id])
  end

  def user_params
    @user_params ||= params.require(:user).permit(*Settings.params_permitted.user)
  end

end
