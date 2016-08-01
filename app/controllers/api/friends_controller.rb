class Api::FriendsController < ApiController
  before_action :authenticate!

  def index
    success(data: current_user.friends)
  end

end
