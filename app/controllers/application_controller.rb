class ApplicationController < ActionController::Base
  before_action :client
  before_action :auth_headers
  before_action :authorization
  before_action :current_user

  private

  def client
    @client_id = Rails.application.secrets.client_id
    @client_secret = Rails.application.secrets.client_secret
  end

  def auth_headers
    @auth_headers = { 'Content-Type': 'application/json' }
    @auth_headers.merge!('Authorization': "Bearer #{session[:access_token]}") if session[:access_token]
  end

  def authorization
    return if session[:access_token] && session[:refresh_token]

    url = "#{SHOWOFF_API_ROOT}/oauth/token"
    payload = @current_user ? refresh_payload : login_payload
    auth_response = RestClient.post(url, payload, auth_headers) rescue nil
    return unless auth_response

    tokens = Decode.json(auth_response.body).data.token
    session[:access_token] = tokens.access_token
    session[:refresh_token] = tokens.refresh_token
  end

  def current_user
    user_response = RestClient.get("#{SHOWOFF_API_ROOT}/api/v1/users/me", auth_headers) rescue nil
    @current_user = Decode.json(user_response.body).data.user if user_response
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
      refresh_token: session[:access_token],
      client_id: @client_id,
      client_secret: @client_secret
    }
  end
end
