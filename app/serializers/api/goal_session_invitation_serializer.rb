class Api::GoalSessionInvitationSerializer < ActiveModel::Serializer
  attributes :id, :inviter, :statement
    
  def inviter
    object.creator.serialize rescue User.last.serialize
  end

  def statement
    [ "challenge you on", object.goal.detail_name ].join(" ") rescue "want challenge you!"
  end
end
