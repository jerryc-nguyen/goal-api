class CreateGoalSessions < ActiveRecord::Migration
  def change
    create_table :goal_sessions do |t|
      t.belongs_to  :creator
      t.belongs_to  :participant
      t.belongs_to  :goal
      t.integer     :score, default: 0
      t.integer     :likes_count, default: 0
      t.integer     :comments_count, default: 0
      t.integer     :views_count, default: 0
      t.integer     :status, default: 0
      t.boolean      :is_accepted, default: false
      t.timestamps null: false
    end

    add_index :goal_sessions, :creator_id
    add_index :goal_sessions, :participant_id
    add_index :goal_sessions, :goal_id
  
  end
end
