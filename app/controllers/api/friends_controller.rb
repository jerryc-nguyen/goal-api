class Api::FriendsController < ApiController
  before_action :authenticate!

  def index
    success(data: current_user.friends)
  end

  def suggested
    friend_ids = current_user.friends.ids
    users = User.where.not(id: friend_ids)
    success(data: users)
  end

end
