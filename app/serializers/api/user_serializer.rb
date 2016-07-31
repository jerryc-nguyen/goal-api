class Api::UserSerializer < ActiveModel::Serializer
    attributes  :id, :display_name, :email, :avatar_url, :first_name, :last_name, :birthday, :phone_number, :latitude, :longitude, :created_at
end
