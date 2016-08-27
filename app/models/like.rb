class Like < ActiveRecord::Base
  acts_as_paranoid

  belongs_to    :likeable, :touch => true, polymorphic: true, counter_cache: true
  belongs_to    :creator, class_name: "User"

  validates :creator_id, presence: true
  
  private

  after_restore do
    Object.const_get(likeable_type).reset_counters(likeable_id, :likes)
  end

  before_destroy do
    Object.const_get(likeable_type).reset_counters(likeable_id, :likes)
  end
  
end
