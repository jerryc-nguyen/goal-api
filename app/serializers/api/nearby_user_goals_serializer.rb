class Api::NearbyUserGoalsSerializer < ActiveModel::Serializer
  attributes :id, :detail_name, :is_challenge, :buddies_count

  def is_challenge
    return false if [87].include?(object.id)
    object.is_challenge
  end

  def buddies_count
    return 2 if [87].include?(object.id)
    object.goal_sessions.pluck(:participant_id).uniq.count
  end
end
