class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user
      t.string   :notificable_type
      t.integer  :notficable_id
      t.string   :message, default: ""
      t.boolean  :is_read, default: false
      t.timestamps null: false
    end

    add_index :notifications, :user_id
    add_index :notifications, [ :notficable_id, :notificable_type ]

  end
end
