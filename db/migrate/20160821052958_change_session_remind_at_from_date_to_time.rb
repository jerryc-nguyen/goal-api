class ChangeSessionRemindAtFromDateToTime < ActiveRecord::Migration
  def change
    change_column :goal_sessions, :remind_user_at, :time
  end
end
