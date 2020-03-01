# frozen_string_literal: true

# Showoff API Requests
class ShowoffAPI
  include RestClient

  def self.get(url, headers)
    RestClient.get(url, headers)
  rescue RestClient::UnprocessableEntity => e
    e.response
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def self.post(url, payload, headers)
    RestClient.post(url, payload, headers)
  rescue RestClient::UnprocessableEntity => e
    e.response
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def self.put(url, payload, headers)
    RestClient.put(url, payload, headers)
  rescue RestClient::UnprocessableEntity => e
    e.response
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end

  def self.delete(url, headers)
    RestClient.delete(url, headers)
  rescue RestClient::UnprocessableEntity => e
    e.response
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end
