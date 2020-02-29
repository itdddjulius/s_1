# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  
  # user_me GET    /users/:user_id/me(.:format)
  def me
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
  
  # users GET    /users(.:format)
  def index
  end
  
  # POST   /users(.:format)
  def create
  end
  
  # new_user GET    /users/new(.:format)
  def new
  end
  
  # edit_user GET    /users/:id/edit(.:format)
  def edit
  end
  
  # user GET    /users/:id(.:format)
  def show
    response = RestClient.get("#{SHOWOFF_API_ROOT}/api/v1/users/#{params[:id]}")
    @user = ActiveSupport::JSON.decode(response.body).data.user
  end
  
  # PATCH or PUT /users/:id(.:format)
  def update
  end

  private

  def authentication_params
    params.permit(
      :client_id,
      :client_secret,
      {
        user: [
          :first_name,
          :last_name,
          :password,
          :email,
          :image_url
        ]
      }
    )
  end
end