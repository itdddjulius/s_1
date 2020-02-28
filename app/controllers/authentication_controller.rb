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
    response = RestClient.post(login_url, payload, @authorization_hash).code
    status_code = response.code
    response_message = ActiveSupport::JSON.decode(response.body)['message']
    flash[status_code.eql?(200) ? :notice : :error] = response_message
    redirect_to root_path
  end

  private

  def payload
    {
      grant_type: "password",
      client_id: @client_id,
      client_secret: @client_secret
    }
  end

  def authentication_params
    params.require(:user).permit(
      :username,
      :password
    )
  end
end