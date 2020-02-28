# frozen_string_literal: true

# Widgets Controller
class WidgetsController < ApplicationController
  before_action :client_variables
  before_action :widgets_api_variables

  # GET / or GET /visible/widgets
  def index
    index_url = "#{@api_url}?#{@client_params}"
    response = RestClient.get(index_url, @authorization_hash)
    @widgets = ActiveSupport::JSON.decode(response.body)['data']['widgets']
  end

  # GET /visible/widgets/search
  def search
    search_term = "term=#{params[:term]}"
    search_url = "#{@api_url}?#{@client_params}&#{search_term}"
    response = RestClient.get(search_url, @authorization_hash)
    @widgets = ActiveSupport::JSON.decode(response.body)['data']['widgets']
    
    render :index
  end

  private

  def client_variables
    @client_id = Rails.application.secrets.client_id
    @client_secret = Rails.application.secrets.client_secret
    @authorization = Rails.application.secrets.authorization
  end

  def widgets_api_variables
    @api_url = "#{SHOWOFF_API_ROOT}/api/v1/widgets/visible"
    @client_params = "client_id=#{@client_id}&client_secret=#{@client_secret}"
    @authorization_hash = { 'Authorization': "Bearer #{@authorization}" }
  end
end