# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  before_action :profile, only: %i[show me]
  
  # user GET    /users/:id(.:format)
  def show
    unless @user
      flash[:error] = user_response.message
      redirect_to root_path
    end
  end
  
  # me_users GET    /users/me(.:format)
  def me
    unless @user
      flash[:error] = user_response.message
      redirect_to root_path
    end
  end
  
  # user_change_password POST   /users/:user_id/change_password(.:format)
  def change_password
  end
  
  # user_check_email GET    /users/:user_id/check_email(.:format)
  def check_email
  end
  
  # user_reset_password POST   /users/:user_id/reset_password(.:format)
  def reset_password
    url = "#{API_V1}/users/reset_password"
    reset_response = ShowoffAPI.post(url, reset_password_payload, @auth_headers)
    success = reset_response.code.zero?
    flash[success ? :notice : :error] = reset_response.message
    
    redirect_to root_path
  end
  
  # POST   /users(.:format)
  def create
    url = "#{API_V1}/users"
    user_response = ShowoffAPI.post(url, create_user_payload, @auth_headers)
    success = user_response.code.zero?
    message = user_response.message
    flash[success ? :notice : :error] = message
    
    redirect_back fallback_location: root_path
  end
  
  # update_my_profile_users PATCH  /users/update_my_profile(.:format)
  def update_my_profile
    url = "#{API_V1}/users/me"
    user_response = ShowoffAPI.put(url, user_payload, @auth_headers)
    success = user_response.code.zero?
    message = user_response.message
    flash[success ? :notice : :error] = message
    
    redirect_back fallback_location: me_users_path
  end

  private

  def profile
    last_url_param = params[:id] || 'me'
    url = "#{API_V1}/users/#{last_url_param}"
    user_response = ShowoffAPI.get(url, @auth_headers)
    @user = user_response&.data&.user
    
    widgets_url = "#{url}/widgets?#{@client_params}"
    widgets_response = ShowoffAPI.get(widgets_url, @auth_headers)
    @widgets = widgets_response.data.widgets
  end

  def user_params
    params.require(:authentication).permit(
      :first_name,
      :last_name,
      :password,
      :email,
      :image_url,
      :date_of_birth
    )
  end

  def user_payload
    { user: user_params.to_h }
  end

  def create_user_payload
    {
      client_id: @client_id,
      client_secret: @client_secret,
      user: user_params.to_h
    }
  end
end