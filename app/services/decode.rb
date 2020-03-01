# frozen_string_literal: true

# Decoder Service
class Decode
  def self.json(body)
    ActiveSupport::JSON.decode(body) rescue { code: 400, message: 'Bad Request' }
  end
end