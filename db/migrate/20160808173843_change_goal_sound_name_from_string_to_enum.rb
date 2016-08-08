class ChangeGoalSoundNameFromStringToEnum < ActiveRecord::Migration
  def change
    remove_column :goals, :sound_name
    add_column    :goals, :sound_name, :integer, default: 0
  end
end
