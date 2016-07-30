class AddSoftDeleteToModel < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime

    add_column :friendships, :deleted_at, :datetime

    add_column :goals, :deleted_at, :datetime

    add_column :likes, :deleted_at, :datetime

    add_column :comments, :deleted_at, :datetime

    add_column :chats, :deleted_at, :datetime

    add_column :notifications, :deleted_at, :datetime

    add_column :goal_sessions, :deleted_at, :datetime
  end
end
