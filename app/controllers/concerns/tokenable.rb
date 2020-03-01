# frozen_string_literal: true

# Concern to manage methods about tokens
module Tokenable
  extend ActiveSupport::Concern

  private

  def set_tokens(response)
    return unless response&.data

    session[:access_token] = response.data.token.access_token
    session[:refresh_token] = response.data.token.refresh_token
  end
end
