# frozen_string_literal: true

# Showoff API Requests
class ShowoffAPI
  include RestClient

  def self.get(url, headers)
    api_request(:get, url, headers)
  end

  def self.post(url, payload, headers)
    api_request(:post, url, headers, payload)
  end

  def self.put(url, payload, headers)
    api_request(:put, url, headers, payload)
  end

  def self.delete(url, headers)
    api_request(:delete, url, headers)
  end

  private

  def self.api_request(http_method, url, headers, payload = nil)
    api_response =
      begin
        if payload
          RestClient.try(http_method, url, payload, headers)
        else
          RestClient.try(http_method, url, headers)
        end
      rescue RestClient::UnprocessableEntity => e
        e.response
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    puts "\n\n=== HTTP_METHOD = #{http_method}"
    puts "=== URL = #{url.split('/').last(3)}"
    puts "=== PAYLOAD = #{payload}" if payload
    puts "=== API_RESPONSE = #{Decode.json(api_response)&.code&.zero?}"
    puts "=====> headers = #{headers}"
    Decode.json(api_response)
  end
end
