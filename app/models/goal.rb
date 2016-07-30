class Goal < ActiveRecord::Base
  belongs_to  :creator, class_name: "User"
  has_many    :goal_sessions
  enum        status: { enabled: 0, disabled: 1 }
end
