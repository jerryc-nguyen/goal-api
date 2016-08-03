class AddStatusToGoalSession < ActiveRecord::Migration
  def change
    add_column :goal_sessions, :is_accepted, :boolean, default: false
  end
end
