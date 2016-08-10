class ChangeGoalRepeatFromConstantToArray < ActiveRecord::Migration
  def change
    remove_column :goals, :repeat_every
    add_column    :goals, :repeat_every, :text, array: true, default: []
  end
end
