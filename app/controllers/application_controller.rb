class ApplicationController < ActionController::Base
  before_action :client
  before_action :auth_headers
  before_action :current_user
  before_action :authorization
  before_action :client_params

  include Tokenable
  include Payloadable
  include ApiRoutable
  include ApiRequestable

  private

  def client
    @client_id = Rails.application.secrets.client_id
    @client_secret = Rails.application.secrets.client_secret
  end

  def auth_headers
    @auth_headers = { 'Content-Type': 'application/json' }
    token = session[:access_token]
    @auth_headers.merge!('Authorization': "Bearer #{token}") if token
  end

  def current_user
    user_response = get(users_me_url)
    @current_user = user_response&.data&.user
  end

  def authorization
    payload = @current_user ? refresh_payload : login_payload
    auth_response = post(oauth_token_url, payload)
    set_tokens(auth_response)
  end
end
