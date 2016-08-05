class ApiController < ActionController::Base

  unless Rails.application.config.consider_all_requests_local
    
    rescue_from StandardError do |exception|
      error(message: exception)
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      error(message: exception.to_s)
    end

    rescue_from ActionController::ParameterMissing do |exception|
      error(message: exception.to_s.capitalize)
    end

    rescue_from ActionController::RoutingError, with: :routing_error

    rescue_from ActiveRecord::RecordNotFound do |exception|
      error(status: 404, message: exception.to_s)
    end

  end

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

  def current_user
    @current_user ||= User.find_by(token: request.headers['X-Api-Token'])
  end

  def authenticate!
    unless current_user
      error(status: 401, message: "You should login to continue.")
    end
  end

  private

  def routing_error
    error(status: 404, message: "No route matches.")
  end

  def validate_friend_id!
    @friend ||= User.find_by_id(params[:friend_id])
    error(message: "Friend for your request does not exists.") unless @friend.present?
  end

end
