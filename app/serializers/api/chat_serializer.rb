class Api::ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id, :receiver_id, :message, :goal_id, :is_read, :sender, :receiver

  def sender
    object.sender.serialize
  end
  
  def receiver
    object.receiver.serialize
  end

end
