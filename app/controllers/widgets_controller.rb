# frozen_string_literal: true

# Widgets Controller
class WidgetsController < ApplicationController
  before_action :widgets_api_variables

  # GET / or GET /visible/widgets
  def index
    index_url = "#{@visible_widgets_api_url}?#{@client_params}"
    response = RestClient.get(index_url, @authorization_hash)
    @widgets = ActiveSupport::JSON.decode(response.body)['data']['widgets']
  end

  # GET /visible/widgets/search
  def search
    search_term = "term=#{params[:term]}"
    search_url = "#{@visible_widgets_api_url}?#{@client_params}&#{search_term}"
    response = RestClient.get(search_url, @authorization_hash)
    @widgets = ActiveSupport::JSON.decode(response.body)['data']['widgets']
    
    render :index
  end

  def widgets_api_variables
    @visible_widgets_api_url = "#{SHOWOFF_API_ROOT}/api/v1/widgets/visible"
    @client_params = "client_id=#{@client_id}&client_secret=#{@client_secret}"
  end
end