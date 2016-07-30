class ApiController < ActionController::Base
  
  def index
    success(data: {"message": "It works!"})
  end

  def success(data: nil, serializer: nil, serialize_options: {}, response_key: nil)
    serializer = Api::SuccessResponse.new(
                  object: data, 
                  serializer: serializer, 
                  serialize_options: serialize_options, 
                  response_key: response_key
                )
    render json: serializer.response
  end

  def error(status: 400, message: nil)
    render json: { status: status, error_message: message }
  end

end
