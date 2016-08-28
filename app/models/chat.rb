class Chat < ActiveRecord::Base
  belongs_to    :sender, class_name: "User"
  belongs_to    :receiver, class_name: "User"

  DEFAULT_SERIALIZER = Api::ChatSerializer

  validates :sender_id, presence: true

  #scope
  scope :messages_of, -> (user) { Chat.where("sender_id = ? OR receiver_id = ?", user.id, user.id).order(id: :asc) }
  scope :load_more_messages, -> (last_message_id) { where("id < ?", last_message_id) }
end
