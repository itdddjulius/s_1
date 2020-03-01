# frozen_string_literal: true

# Concern to manage the permit params
module Permitable
  extend ActiveSupport::Concern

  private

  # Authentication

  def auth_params
    params.require(:authentication).permit(
      :email,
      :password
    )
  end

  # Users

  def registration_params
    params.require(:registration).permit(
      :first_name,
      :last_name,
      :email,
      :password
    )
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :image_url
    )
  end

  def password_params
    params.require(:password).permit(
      :current_password,
      :new_password
    )
  end

  # Widgets

  def widget_params
    params.require(:widget).permit(
      :name, :description, :kind
    )
  end
end
