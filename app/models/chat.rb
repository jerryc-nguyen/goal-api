class Chat < ActiveRecord::Base
  belongs_to    :sender, class_name: "User"
  belongs_to    :receiver, class_name: "User"

  DEFAULT_SERIALIZER = Api::ChatSerializer

  validates :sender_id, presence: true

  #scope
  scope :messages_of, -> (user) { Chat.where("sender_id = ? OR receiver_id = ?", user.id, user.id).order(id: :asc) }
  scope :load_more_messages, -> (last_message_id) { where("id < ?", last_message_id) }

  scope :buddies_chat_for, -> (goal_id) {
    Chat.where(goal_id: goal_id).order(id: :desc)
  }

  scope :friend_chat_for, -> (user_id, friend_id) {
    Chat.where("(chats.sender_id = ? AND chats.receiver_id = ?) OR (chats.sender_id = ? AND chats.receiver_id = ?)", user_id, friend_id, friend_id, user_id).order(id: :desc)
  }

end
