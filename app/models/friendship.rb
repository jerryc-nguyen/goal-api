class Friendship < ActiveRecord::Base
  belongs_to :requestor, class_name: "User", foreign_key: :friendable_id
  belongs_to :acceptor, class_name: "User", foreign_key: :friend_id
end
