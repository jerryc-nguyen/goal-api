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
      error(message: user.full_messages.to_sentence)
    end
  end

  def update
    if @user.update(user_params)
      success(data: @user)
    else
      error(message: @user.full_messages.to_sentence)
    end
  end

  def destroy
    if @user.destroy
      success(data: { message: "Deleted successfuly!" })
    else
      error(message: @user.full_messages.to_sentence)
    end
  end

  private

  def find_user
    @user ||= User.find(params[:id])
  end

  def user_params
    @user_params ||= params.require(:user).permit(*Settings.params_permitted.user)
  end

end
