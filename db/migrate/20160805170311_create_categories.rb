class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string      :name, default: ""
      t.boolean     :is_default, default: false
      t.integer     :nth
      t.belongs_to  :user
      t.timestamps null: false
    end
    
    add_index :categories, :user_id
  end
end
