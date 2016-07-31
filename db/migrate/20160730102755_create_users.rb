class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :display_name, default: ""
      t.string    :email, default: ""
      t.string    :avatar_url, default: ""
      t.string    :first_name, default: ""
      t.string    :last_name, default: ""
      t.datetime  :birthday
      t.string    :phone_number
      t.string    :latitude, default: ""
      t.string    :longitude, default: ""

      # social login
      t.integer   :auth_system
      t.string    :auth_system_id
      t.string    :token
      
      t.timestamps null: false
    end
  end
end
