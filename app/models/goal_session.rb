class GoalSession < ActiveRecord::Base
  include Notificable
  include Likeable
  include Commentable
  include PublicActivity::Model
  tracked

  belongs_to :creator, class_name: "User"
  belongs_to :participant, class_name: "User"
  belongs_to :goal
  
end
