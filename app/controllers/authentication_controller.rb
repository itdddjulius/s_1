# frozen_string_literal: true

# Authentication Controller
class AuthenticationController < ApplicationController
  before_action :auth_url

  # revoke_authentication_index POST   /authentication/revoke(.:format)
  def revoke
    revoke_url = "#{SHOWOFF_API_ROOT}/oauth/revoke"
    revoke_response = authenticate(revoke_url, { token: session[:access_token] })
    if revoke_response
      message = Decode.json(revoke_response.body).data.message
      flash[:notice] = message
      reset_session
    else
      flash[:error] = 'You can\'t go out. You are trapped'
    end

    redirect_back fallback_location: root_path
  end
  
  # authentication_index POST   /authentication(.:format) 
  def create
    login_response = authenticate(@auth_url, auth_payload)
    success = login_response.code.eql?(200)
    decoded_response = Decode.json(login_response.body)
    flash[success ? :notice : :error] = decoded_response.message
    if decoded_response.data
      session[:access_token] = decoded_response.data.token.access_token
      session[:refresh_token] = decoded_response.data.token.refresh_token
    end

    redirect_back fallback_location: root_path
  end

  private

  def auth_url
    @auth_url = "#{SHOWOFF_API_ROOT}/oauth/token"
  end

  def authenticate(url, payload)
    ShowoffAPI.post(url, payload, @auth_headers)
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