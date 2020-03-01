# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  
  # user_me GET    /users/:user_id/me(.:format)
  def me
    url = "#{SHOWOFF_API_ROOT}/api/v1/users/me"
    user_response = ShowoffAPI.get(url, @auth_headers)
    @user = Decode.json(user_response.body).data.user
  end
  
  # user_change_password POST   /users/:user_id/change_password(.:format)
  def change_password
  end
  
  # user_check_email GET    /users/:user_id/check_email(.:format)
  def check_email
  end
  
  # user_reset_password POST   /users/:user_id/reset_password(.:format)
  def reset_password
  end
  
  # POST   /users(.:format)
  def create
  end
  
  # user GET    /users/:id(.:format)
  def show
    url = "#{SHOWOFF_API_ROOT}/api/v1/users/#{params[:id]}"
    user_response = ShowoffAPI.get(url, @auth_headers)
    @user = Decode.json(user_response.body).data.user
  end
  
  # update_my_profile_users PATCH  /users/update_my_profile(.:format)
  def update_my_profile
    url = "#{SHOWOFF_API_ROOT}/api/v1/users/me"
    user_response = ShowoffAPI.put(url, user_payload, @auth_headers)
    success = user_response.code.eql?(200)
    message = Decode.json(user_response.body).message if user_response.body
    flash[success ? :notice : :error] = message || 'Bad request'

    
    redirect_back fallback_location: me_users_path
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :password,
      :email,
      :image_url
    )
  end

  def user_payload
    { user: user_params.to_h }
  end
end