class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :creator
      t.string    :content, default: ""
      t.integer   :commentable_id
      t.string    :commentable_type
      t.timestamps null: false
    end

    add_index :comments, :creator_id
    add_index :comments, [ :commentable_id, :commentable_type ]

  end
end
