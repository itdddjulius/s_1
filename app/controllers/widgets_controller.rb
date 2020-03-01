# frozen_string_literal: true

# Widgets Controller
class WidgetsController < ApplicationController
  before_action :visible_widgets_api_variables

  # root_path GET / OR widgets_path GET    /visible/widgets(.:format)
  def index
    index_url = "#{@visible_widgets_api_url}?#{@client_params}"
    widgets_response = ShowoffAPI.get(index_url, @auth_headers)
    @widgets = Decode.json(widgets_response.body).data.widgets
  end

  # search_widgets GET    /visible/widgets/search(.:format)
  def search
    search_term = "term=#{params[:term]}"
    search_url = "#{@visible_widgets_api_url}?#{@client_params}&#{search_term}"
    widgets_response = ShowoffAPI.get(search_url, @auth_headers)
    @widgets = Decode.json(widgets_response.body).data.widgets
    
    render :index
  end

  # mine_widgets GET    /widgets/mine(.:format)
  def mine
    widgets_response = ShowoffAPI.get(@my_widgets_api_url, @auth_headers)
    @widgets = Decode.json(widgets_response.body).data.widgets
  end

  # POST   /widgets(.:format)
  def create
    widget_response = ShowoffAPI.post(@my_widgets_api_url, widget_payload, @auth_headers)
    success = widget_response.code.eql?(200)
    response_message = Decode.json(widget_response.body).message
    flash[success ? :notice : :error] = response_message
  end

  # PATCH  /widgets/:id(.:format) OR PUT    /widgets/:id(.:format)
  def update
    url = "#{@my_widgets_api_url}/#{params[:id]}"
    destroy_response = ShowoffAPI.put(url, widget_payload, @auth_headers)
    flash[success ? :notice : :error] = destroy_response.message
    
    redirect_back fallback_location: mine_widgets_path
  end

  # DELETE /widgets/:id(.:format)
  def destroy
    url = "#{@my_widgets_api_url}/#{params[:id]}"
    destroy_response = ShowoffAPI.delete(url, @auth_headers)
    flash[success ? :notice : :error] = destroy_response.message
    
    redirect_back fallback_location: mine_widgets_path
  end

  private

  def visible_widgets_api_variables
    @my_widgets_api_url = "#{SHOWOFF_API_ROOT}/api/v1/widgets"
    @visible_widgets_api_url = "#{SHOWOFF_API_ROOT}/api/v1/widgets/visible"
    @client_params = "client_id=#{@client_id}&client_secret=#{@client_secret}"
  end

  def widget_params
    params.require(:widget).permit(
      :name, :description, :kind
    )
  end

  def widget_payload
    { widget: widget_params.to_h }
  end
end