class ApplicationController < ActionController::Base
  before_action :client
  before_action :user
  before_action :auth_headers
  before_action :authorization
  before_action :current_user

  private

  def client
    @client_id = Rails.application.secrets.client_id
    @client_secret = Rails.application.secrets.client_secret
  end

  def user
    @user_email = Rails.application.secrets.user_email
    @user_password = Rails.application.secrets.user_password
  end

  def auth_headers
     @auth_headers = {
      'Content-Type': 'application/json'
    }
    @auth_headers.merge!('Authorization': "Bearer #{@token}") if @token
  end

  def authorization
    url = "#{SHOWOFF_API_ROOT}/oauth/token"
    payload = @current_user ? refresh_payload : login_payload
    auth_response = RestClient.post(url, payload, auth_headers)
    @token = ActiveSupport::JSON.decode(auth_response.body).data.token.access_token if auth_response
  end

  def current_user
    user_response = RestClient.get("#{SHOWOFF_API_ROOT}/api/v1/users/me", auth_headers) rescue nil
    @current_user = ActiveSupport::JSON.decode(user_response.body).data.user if user_response
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
      refresh_token: @token,
      client_id: @client_id,
      client_secret: @client_secret
    }
  end
end
