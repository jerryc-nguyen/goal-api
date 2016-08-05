# NOTE: class include this concern must be declare the default
# serializer constant named: DEFAULT_SERIALIZER
module Serializeable
  extend ActiveSupport::Concern

  included do
  end

  #use to serialize json of object with current user options
  #if logic require more than one options please
  #use default serializer init style for best customizable
  def serialize(serializer = nil, current_user = nil)
    serializer ||= self.class::DEFAULT_SERIALIZER
    serializer.new(self, current_user: current_user).attributes
  end

  module ClassMethods
    def serialize_items(items, current_user = nil, serializer = nil)
      serializer ||= self::DEFAULT_SERIALIZER
      items.map{ |item| item.serialize(serializer, current_user) }
    end
  end

end
