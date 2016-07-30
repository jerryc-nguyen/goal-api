class Chat < ActiveRecord::Base
  belongs_to    :sender, class_name: "User"
  belongs_to    :receiver, class_name: "User"

  #scope
  scope :messages_of, -> (user_id) { Chat.where("sender_id = ? OR receiver_id = ?", user_id, user_id) }
  scope :load_more_messages, -> (last_message_id) { where("id < ?", last_message_id) }
end
