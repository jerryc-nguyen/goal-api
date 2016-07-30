class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.belongs_to :creator
      t.integer   :likeable_id
      t.string    :likeable_type
      t.timestamps null: false
    end

    add_index :likes, :creator_id
    add_index :likes, [ :likeable_id, :likeable_type ]
    
  end
end
