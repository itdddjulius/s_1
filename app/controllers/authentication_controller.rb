# frozen_string_literal: true

# Authentication Controller
class AuthenticationController < ApplicationController

  # revoke_authentication_index POST   /authentication/revoke(.:format)
  def revoke
    revoke_url = "#{SHOWOFF_API_ROOT}/oauth/token"
    response = authenticate(revoke_url)
  end
  
  # refresh_authentication_index POST   /authentication/refresh(.:format)
  def refresh
  end
  
  # authentication_index POST   /authentication(.:format) 
  def create
    login_url = "#{SHOWOFF_API_ROOT}/oauth/token"
    response = authenticate(login_url)
    status_code = response&.code
    response_message = ActiveSupport::JSON.decode(response&.body).message rescue 'Unknown Error'
    success = status_code.eql?(200)
    if success
      flash[:notice] = response_message
    else
      flash[:error] = response_message
    end

    redirect_to root_path
  end

  private

  def authenticate(url)
    RestClient.post(url, auth_payload)
  rescue RestClient::UnprocessableEntity => e
    e.response
  rescue RestClient::ExceptionWithResponse => e
    e.response
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