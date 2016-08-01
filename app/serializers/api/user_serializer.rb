class Api::UserSerializer < ActiveModel::Serializer
  attributes  :id, :display_name, :email, :avatar_url, :first_name, :last_name, :birthday, :phone_number, :latitude, :longitude, :created_at, :token

  def display_name
    object.auth_name || "#{object.first_name} #{object.last_name}"
  end
end
