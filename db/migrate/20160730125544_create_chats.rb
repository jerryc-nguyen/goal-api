class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.belongs_to  :sender
      t.belongs_to  :receiver
      t.string      :message, default: ""
      t.timestamps null: false
    end

    add_index :chats, :sender_id
    add_index :chats, :receiver_id
    
  end
end
