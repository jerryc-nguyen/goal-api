class Api::FriendsController < ApiController
  before_action :authenticate!

  def index
    success(data: current_user.friends)
  end

  def suggested
    except_user_ids = goal_buddies.ids + [current_user.id]
    users = User.where.not(id: except_user_ids)
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
