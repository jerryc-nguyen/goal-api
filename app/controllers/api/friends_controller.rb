class Api::FriendsController < ApiController
  before_action :authenticate!

  def index
    success(data: current_user.friends)
  end

  def suggested
    friend_ids = current_user.friends.ids
    success(data: User.where.not(id: friend_ids))
  end

end
