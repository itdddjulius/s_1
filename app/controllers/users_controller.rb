# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  include Tokenable
  include Payloadable
  include ApiRoutable
  include ApiRequestable
  include Flashable
  include Permitable

  before_action :profile, only: %i[show me search_widgets]
  
  # user GET    /users/:id(.:format)
  def show; end
  
  # me_users GET    /users/me(.:format)
  def me; end

  # user_search_widgets GET    /users/:user_id/search_widgets(.:format)
  def search_widgets; end
  
  # user_change_password POST   /users/:user_id/change_password(.:format)
  def change_password
    change_password_response = post(change_password_url, change_password_payload)
    flash_message(change_password_response)
    set_tokens(change_password_response)

    redirect_back fallback_location: me_users_path
  end
  
  # user_reset_password POST   /users/:user_id/reset_password(.:format)
  def reset_password
    reset_response = post(reset_password_url, reset_password_payload)
    flash_message(reset_response)
    
    redirect_to root_path
  end
  
  # POST   /users(.:format)
  def create
    user_response = post(users_url, create_user_payload)
    flash_message(user_response)
    
    redirect_back fallback_location: root_path
  end
  
  # update_my_profile_users PATCH  /users/update_my_profile(.:format)
  def update_my_profile
    user_response = put(users_me_url, user_payload)
    flash_message(user_response)
    
    redirect_back fallback_location: me_users_path
  end

  private

  def profile
    user_response = get(profile_url)
    @user = user_response&.data&.user

    unless @user
      flash[:error] = user_response.message
      redirect_to root_path
    end

    widgets_response = get(profile_widgets_url)
    @widgets = widgets_response&.data&.widgets
  end
end