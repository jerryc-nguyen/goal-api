class Api::AuthController < ApiController
  
  def facebook
    if facebook_login_system.login?
      success(data: facebook_login_system.logged_user, serializer: Api::AuthUserSerializer)
    else
      error(message: facebook_login_system.errors)
    end
  end

  private

  def facebook_login_system
    @facebook_login_system ||= Auth::Facebook.new(params[:token])
  end

end
