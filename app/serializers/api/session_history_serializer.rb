class Api::SessionHistorySerializer < ActiveModel::Serializer
  attributes :score, :created_at
end
