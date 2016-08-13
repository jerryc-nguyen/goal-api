class Api::CategorySerializer < ActiveModel::Serializer
  attributes  :id, :name, :nth, :is_default, :selected_color
end
