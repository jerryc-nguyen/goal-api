class Comment < ActiveRecord::Base
  acts_as_paranoid
  
  include Serializeable
  include Likeable

  DEFAULT_SERIALIZER = Api::CommentSerializer

  belongs_to      :commentable, polymorphic: true, counter_cache: true
  belongs_to      :creator, class_name: "User", foreign_key: :creator_id

  validates :creator_id, presence: true
  
  private

  after_restore do
    Object.const_get(commentable_type).reset_counters(commentable_id, :comments)
  end

  before_destroy do
    Object.const_get(commentable_type).reset_counters(commentable_id, :comments)
  end
  
end
