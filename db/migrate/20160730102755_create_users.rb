class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :email, default: ""
      t.string    :avatar_url, default: ""
      t.string    :first_name, default: ""
      t.string    :last_name, default: ""
      t.datetime  :birthday
      t.string    :phone_number
      t.string    :latitude, default: ""
      t.string    :longitude, default: ""
      t.string    :token #app api access token

      # social login
      t.integer   :auth_system
      t.string    :auth_system_id
      t.string    :auth_token
      t.string    :auth_name
      t.string    :auth_picture

      t.timestamps null: false
    end
  end
end
