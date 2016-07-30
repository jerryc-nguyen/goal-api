class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :friendable_id
      t.integer :friend_id 
      t.timestamps null: false
    end

    add_index :friendships, [:friendable_id, :friend_id], :unique => true

  end
end
