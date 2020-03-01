# frozen_string_literal: true

# Concern to manage API routes
module ApiRoutable
  extend ActiveSupport::Concern

  private

  # Authentication

  def oauth_token_url
    "#{API_ROOT}/oauth/token" # Authentication - Create/Refresh
  end

  def revoke_url
    "#{API_ROOT}/oauth/revoke" # Authentication - Revoke
  end

  # Users

  def users_url
    "#{API_V1}/users" # Users - Create
  end
  
  def reset_password_url
    "#{users_url}/reset_password" # Users - Reset Password
  end

  def users_me_url
    "#{users_url}/me" # Users - Show (Me)
  end
  
  def change_password_url
    "#{users_me_url}/password" # Users - Change Password
  end

  def client_params
    "client_id=#{@client_id}&client_secret=#{@client_secret}"
  end

  def profile_url
    last_url_param = params[:id] || params[:user_id] || 'me'
    "#{API_V1}/users/#{last_url_param}" # Users - Show (Me) / Show (ID)
  end

  # Widgets

  def profile_widgets_url
    url = "#{profile_url}/widgets?#{client_params}"
    if action_name.include?('search')
      "#{url}&term=#{params[:term]}" # Widgets - Visible - Index w/ Term
    else
      url # Widgets - Visible - Index
    end
  end

  def my_widgets_url
    "#{API_V1}/widgets" # Widgets - Index
  end

  def widget_url
    "#{API_V1}/widgets/#{params[:id]}" # Widgets - Show/Update/Destroy
  end

  def visible_widgets_url
    "#{API_V1}/widgets/visible?#{client_params}" # Widgets - Visible - Index
  end
  
  def search_widgets_url
    "#{visible_widgets_url}&term=#{params[:term]}" # Widgets/Visible/Index
  end
end
