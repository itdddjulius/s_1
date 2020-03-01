# frozen_string_literal: true

# Authentication Controller
class AuthenticationController < ApplicationController
  before_action :auth_url

  # revoke_authentication_index POST   /authentication/revoke(.:format)
  def revoke
    revoke_url = "#{API_ROOT}/oauth/revoke"
    revoke_response = ShowoffAPI.post(revoke_url, revoke_payload, @auth_headers)
    if revoke_response
      message = revoke_response&.data&.message
      flash[:notice] = message
      reset_session
    else
      flash[:error] = 'You can\'t go out. You are trapped'
    end

    redirect_back fallback_location: root_path
  end
  
  # authentication_index POST   /authentication(.:format) 
  def create
    login_response = ShowoffAPI.post(@auth_url, auth_payload, @auth_headers)
    success = login_response.code.zero?
    flash[success ? :notice : :error] = login_response.message
    set_tokens(login_response)

    redirect_back fallback_location: root_path
  end

  private

  def auth_url
    @auth_url = "#{API_ROOT}/oauth/token"
  end

  def revoke_payload
    { token: session[:access_token] }
  end

  def auth_payload
    {
      grant_type: 'password',
      client_id: @client_id,
      client_secret: @client_secret,
      username: auth_params[:email],
      password: auth_params[:password]
    }
  end

  def auth_params
    params.require(:authentication).permit(
      :email,
      :password
    )
  end
end