# frozen_string_literal: true

# Concern to manage flash messages
module Flashable
  extend ActiveSupport::Concern

  private

  def flash_message(api_response)
    success = api_response.code.zero?
    flash[success ? :notice : :error] = api_response.message
  end
end
