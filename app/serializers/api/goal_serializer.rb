class Api::GoalSerializer < ActiveModel::Serializer
  attributes :id, :name, :detail_name, :start_at, :repeat_every, :duration, :sound_name, :is_challenge, :is_default
end
