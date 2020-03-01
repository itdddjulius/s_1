# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  before_action :profile, only: %i[show me search_widgets]
  
  # user GET    /users/:id(.:format)
  def show; end
  
  # me_users GET    /users/me(.:format)
  def me; end

  # user_search_widgets GET    /users/:user_id/search_widgets(.:format)
  def search_widgets; end
  
  # user_change_password POST   /users/:user_id/change_password(.:format)
  def change_password
    url = "#{API_V1}/users/me/password"
    change_password_response = ShowoffAPI.post(url, change_password_payload, @auth_headers)
    success = change_password_response.code.zero?
    flash[success ? :notice : :error] = change_password_response.message
    set_tokens(change_password_response)

    redirect_back fallback_location: me_users_path
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
    user_response = ShowoffAPI.get(profile_url, @auth_headers)
    @user = user_response&.data&.user

    unless @user
      flash[:error] = user_response.message
      redirect_to root_path
    end

    widgets_response = ShowoffAPI.get(widgets_url, @auth_headers)
    @widgets = widgets_response&.data&.widgets
  end

  def profile_url
    last_url_param = params[:id] || params[:user_id] || 'me'
    "#{API_V1}/users/#{last_url_param}"
  end

  def widgets_url
    url = "#{profile_url}/widgets?#{@client_params}"
    action_name.eql?('search_widgets') ? "#{url}&term=#{params[:term]}" : url
  end

  def user_params
    params.require(:registration).permit(
      :first_name,
      :last_name,
      :password,
      :email,
      :image_url,
      :date_of_birth
    )
  end

  def password_params
    params.require(:password).permit(
      :current_password,
      :new_password
    )
  end

  def user_params_with_formatted_date_of_birth
    user_params[:date_of_birth].to_date.to_time.to_i
    user_params
  end

  def user_payload
    { user: user_params_with_formatted_date_of_birth.to_h }
  end

  def create_user_payload
    {
      client_id: @client_id,
      client_secret: @client_secret,
      user: user_params_with_formatted_date_of_birth.to_h
    }
  end

  def change_password_payload
    { user: password_params.to_h }
  end
end