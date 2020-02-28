class ApplicationController < ActionController::Base
  before_action :client_variables

  private

  def client_variables
    @client_id = Rails.application.secrets.client_id
    @client_secret = Rails.application.secrets.client_secret
    @authorization = Rails.application.secrets.authorization
    @authorization_hash = { 'Authorization': "Bearer #{@authorization}" }
  end
end
