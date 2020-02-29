# frozen_string_literal: true

# Widgets Controller
class WidgetsController < ApplicationController
  before_action :visible_widgets_api_variables

  # root_path GET / OR widgets_path GET    /visible/widgets(.:format)
  def index
    index_url = "#{@visible_widgets_api_url}?#{@client_params}"
    widgets_response = RestClient.get(index_url, @auth_headers)
    @widgets = ActiveSupport::JSON.decode(widgets_response.body).data.widgets
  end

  # search_widgets GET    /visible/widgets/search(.:format)
  def search
    search_term = "term=#{params[:term]}"
    search_url = "#{@visible_widgets_api_url}?#{@client_params}&#{search_term}"
    widgets_response = RestClient.get(search_url, @auth_headers)
    @widgets = ActiveSupport::JSON.decode(widgets_response.body).data.widgets
    
    render :index
  end

  # mine_widgets GET    /widgets/mine(.:format)
  def mine
    my_widgets_api_url = "#{SHOWOFF_API_ROOT}/api/v1/widgets"
    widgets_response = RestClient.get(my_widgets_api_url, @auth_headers)
    @widgets = ActiveSupport::JSON.decode(widgets_response.body).data.widgets
  end

  # POST   /widgets(.:format)
  def create
  end

  # PATCH  /widgets/:id(.:format) OR PUT    /widgets/:id(.:format)
  def update
  end

  # DELETE /widgets/:id(.:format)
  def destroy
  end

  private

  def visible_widgets_api_variables
    @visible_widgets_api_url = "#{SHOWOFF_API_ROOT}/api/v1/widgets/visible"
    @client_params = "client_id=#{@client_id}&client_secret=#{@client_secret}"
  end
end