class Api::FriendsController < ApiController
  before_action :authenticate!

  def index
    success(data: current_user.friends)
  end

  def suggested
    except_user_ids = current_user.friends.ids + [current_user.id]
    users = User.where.not(id: except_user_ids).order(id: :desc)
    success(data: users)
  end

  def buddies
    success(data: goal_buddies)
  end
  
  private

  def goal_buddies
    @goal_buddies ||= User.goal_buddies_of(current_user)
  end
end
