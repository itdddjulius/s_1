# frozen_string_literal: true

# Authentication Controller
class AuthenticationController < ApplicationController

  # revoke_authentication_index POST   /authentication/revoke(.:format)
  def revoke
  end
  
  # refresh_authentication_index POST   /authentication/refresh(.:format)
  def refresh
  end
  
  # authentication_index POST   /authentication(.:format) 
  def create
    login_url = "#{SHOWOFF_API_ROOT}/oauth/token"
    begin
      response = RestClient.post(login_url, payload)
    rescue RestClient::UnprocessableEntity => e
      e.response
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

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

  def payload
    {
      grant_type: 'password',
      client_id: @client_id,
      client_secret: @client_secret,
      username: user_authentication_params[:email],
      password: user_authentication_params[:password]
    }.to_json
  end

  def user_authentication_params
    params.require(:user).permit(
      :email,
      :password
    )
  end
end