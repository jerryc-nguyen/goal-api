class Api::UserSerializer < ActiveModel::Serializer
  attributes  :id, :id_str, :display_name, :email, :avatar_url, :first_name, :last_name, :birthday, :phone_number, :latitude, :longitude, :created_at, :token, :goal_count, :is_friend, :is_pending_friend, :airship_tag, :realtime_channel

  def id_str
    object.id.to_s
  end

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

end
