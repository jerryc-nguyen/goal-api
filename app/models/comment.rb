class Comment < ActiveRecord::Base
  acts_as_paranoid
  
  belongs_to      :commentable, polymorphic: true, counter_cache: true
  belongs_to      :creator, class_name: "User", foreign_key: :creator_id
end
