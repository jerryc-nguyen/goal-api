class Api::SuccessResponse
  attr_reader :response

  def initialize(object: nil, serializer: nil, serialize_options: {}, response_key: nil)
    result = if iterable?(object)
      serialize_collection(object, serializer, serialize_options)
    else
      serialize_single(object, serializer, serialize_options)
    end

    @response = { status: 200 }
    response_key ||= "data"
    @response[response_key] = result 
  end

  def serialize_collection(collection, serializer, serialize_options)
    return [] if collection.to_a.empty?

    if collection.first.try(:errors) # this is Active record model
      serializer ||= collection.first.class::DEFAULT_SERIALIZER
      collection.map{|item| serializer.new(item, serialize_options).attributes }
    else
      collection
    end
  end

  def serialize_single(object, serializer, serialize_options)
    if object.try(:errors) #active record object
      serializer ||= object.class::DEFAULT_SERIALIZER
      serializer.new(object, serialize_options).attributes
    else
      object
    end
  end

  def iterable?(object)
    if object.is_a? Hash
      false
    elsif object.is_a? Range
      object.begin.respond_to? :succ
    else
      object.respond_to? :each
    end
  end

end
