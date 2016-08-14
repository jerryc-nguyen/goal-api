class Api::GoalSerializer < ActiveModel::Serializer
  attributes :id, :name, :detail_name, :start_at, :repeat_every, :duration, :sound_name, :is_challenge, :is_default, :category_selected_color, :start_at_interval, :end_at_interval, :start_at_hour, :start_at_minute
end
