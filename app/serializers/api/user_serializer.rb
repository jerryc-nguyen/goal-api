class Api::UserSerializer < ActiveModel::Serializer
  attributes  :id, :display_name, :email, :avatar_url, :first_name, :last_name, :birthday, :phone_number, :latitude, :longitude, :created_at

  def display_name
    object.auth_name
  end
end
