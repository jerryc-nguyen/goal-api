class ChangeGoalStartAtFromDateToTime < ActiveRecord::Migration
  def change
    change_column :goals, :start_at, :time
  end
end
