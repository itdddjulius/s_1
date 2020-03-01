# frozen_string_literal: true

# Concern to manage API payloads
module Payloadable
  extend ActiveSupport::Concern

  private

  # Authentication

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

  # Users

  def user_payload
    { user: user_params.to_h }
  end

  def create_user_payload
    {
      client_id: @client_id,
      client_secret: @client_secret,
      user: registration_params.to_h
    }
  end

  def change_password_payload
    { user: password_params.to_h }
  end

  # Widgets

  def widget_payload
    { widget: widget_params.to_h }
  end
end
