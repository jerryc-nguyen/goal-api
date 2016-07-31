class Goal < ActiveRecord::Base
  
  DEFAULT_SERIALIZER = Api::GoalSerializer

  belongs_to  :creator, class_name: "User"
  has_many    :goal_sessions
  enum        status: { enabled: 0, disabled: 1 }


end
