class AddFieldToChat < ActiveRecord::Migration
  
  def change
    add_column :chats, :is_read, :boolean, default: false
    add_column :chats, :goal_id, :integer
  end

end
