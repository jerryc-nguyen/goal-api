class AddDateTimesToGoalSession < ActiveRecord::Migration
  
  def change
    add_column :goal_sessions, :user_start_at, :datetime
    add_column :goal_sessions, :user_completed_at, :datetime
    add_column :goal_sessions, :remind_user_at, :datetime
  end

end
