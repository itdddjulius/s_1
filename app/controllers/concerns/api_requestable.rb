# frozen_string_literal: true

# Concern to manage API requests
module ApiRequestable
  extend ActiveSupport::Concern

  private

  def get(url)
    ShowoffAPI.get(url, @auth_headers)
  end

  def post(url, payload)
    ShowoffAPI.post(url, payload, @auth_headers)
  end

  def put(url, payload)
    ShowoffAPI.put(url, payload, @auth_headers)
  end

  def delete(url)
    ShowoffAPI.delete(url, @auth_headers)
  end
end
