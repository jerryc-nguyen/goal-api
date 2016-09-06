class Api::ChatSerializer < ActiveModel::Serializer
  attributes :id, :sender_id_str, :sender_id, :receiver_id, :message, :goal_id, :is_read, :sender, :goal, :receiver, :formatted_created_at, :created_at

  def sender_id_str
    object.sender_id.to_s
  end

  def sender
    object.sender.serialize
  end
  
  def goal
    return nil unless object.goal_id.present?
    object.goal.serialize
  end

  def receiver
    return nil unless object.receiver.present?
    object.receiver.serialize
  end

  def formatted_created_at
    object.created_at.strftime("%I:%M %P")
  end
end
