# frozen_string_literal: true

# Decoder Service
class Decode
  def self.json(body)
    ActiveSupport::JSON.decode(body)
  end
end