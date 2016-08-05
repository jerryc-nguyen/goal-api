class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string    :name, default: ""
      t.datetime  :start_at
      t.integer   :repeat_every
      t.integer   :duration, default: 0
      t.string    :sound_name
      t.boolean   :is_challenge, default: false
      t.boolean   :is_default, default: false
      t.integer   :status, default: 0
      t.belongs_to :creator
      t.belongs_to :category

      t.timestamps null: false
    end
    
    add_index :goals, :creator_id
    add_index :goals, :category_id

  end
end
