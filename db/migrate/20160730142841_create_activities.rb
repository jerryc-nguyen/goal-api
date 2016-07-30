# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :owner, :polymorphic => true
      t.string  :key
      t.json    :parameters, default: {}

      t.timestamps
    end

    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, [:owner_id, :owner_type]
  end
  
  # Drop table
  def self.down
    drop_table :activities
  end
end
