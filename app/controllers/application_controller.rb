class ApplicationController < ActionController::Base
  before_action :client
  before_action :auth_headers
  before_action :current_user
  before_action :authorization
  before_action :client_params

  private

  def client
    @client_id = Rails.application.secrets.client_id
    @client_secret = Rails.application.secrets.client_secret
  end

  def auth_headers
    @auth_headers = { 'Content-Type': 'application/json' }
    @auth_headers.merge!('Authorization': "Bearer #{session[:access_token]}") if session[:access_token]
  end

  def current_user
    user_response = ShowoffAPI.get("#{API_V1}/users/me", @auth_headers)
    @current_user = user_response&.data&.user
  end

  def authorization
    url = "#{API_ROOT}/oauth/token"
    payload = @current_user ? refresh_payload : login_payload
    auth_response = ShowoffAPI.post(url, payload, @auth_headers)
    set_tokens(auth_response)
  end

  def client_params
    @client_params = "client_id=#{@client_id}&client_secret=#{@client_secret}"
  end

  protected

  def login_payload
    {
      grant_type: "password",
      client_id: @client_id,
      client_secret: @client_secret,
      username: @user_email,
      password: @user_password
    }
  end

  def refresh_payload
    {
      grant_type: "refresh_token",
      refresh_token: session[:refresh_token],
      client_id: @client_id,
      client_secret: @client_secret
    }
  end

  def set_tokens(response)
    return unless response&.data

    session[:access_token] = response.data.token.access_token
    session[:refresh_token] = response.data.token.refresh_token
  end
end
