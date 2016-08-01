class Auth::Facebook

  attr_reader :errors, :logged_user

  def initialize(access_token)
    @access_token = access_token
  end

  def login?
    fb_user = fetch_fb_user
    
    if fb_user.blank?
      @errors = "Facebook token is invalid."
      return false
    elsif fb_user[:email].blank?
      @errors = "Please confirm your facebook email."
      return false
    end

    @logged_user = User.facebook.find_by(auth_system_id: fb_user[:id]) || create_user_for(fb_user) 
    @logged_user.auth_token = @access_token
    @logged_user.save
    true
  end

  private

  def create_user_for(fb_user)
    User.facebook.create(
      auth_name: fb_user[:name], 
      email: fb_user[:email], 
      auth_picture: fb_user[:picture].to_json,
      auth_system_id: fb_user[:id],
      auth_token: @access_token
    )
  end

  def fetch_fb_user
    begin
      graph = Koala::Facebook::API.new(@access_token)
      graph.get_object('me', fields: ['id', 'name', 'email', 'birthday', 'gender', 'last_name', 'first_name', 'picture']).symbolize_keys
    rescue => e
      nil
    end
  end


end
