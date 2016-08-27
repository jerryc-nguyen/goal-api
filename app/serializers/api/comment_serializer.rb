class Api::CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :creator, :likes_count

  def creator
    object.creator.serialize
  end
  
end
