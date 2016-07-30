class Like < ActiveRecord::Base
  belongs_to    :likeable, :touch => true, polymorphic: true, counter_cache: true
  belongs_to    :creator, class_name: "User"
end
