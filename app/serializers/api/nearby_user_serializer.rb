class Api::NearbyUserSerializer < Api::UserSerializer

  def goal_count
    Goal.joined_by(object).size
  end

  def is_friend
    return false if current_user.blank?
    current_user.friend_with?(object) 
  end

  def is_pending_friend
    return false if current_user.blank?
    current_user.pending_friend_with?(object)
  end

  def current_user
    @current_user ||= @instance_options[:current_user]
  end

  def active_goals
    object.goals.map{ |goal| goal.serialize(Api::NearbyUserGoalsSerializer) }
  end

end
