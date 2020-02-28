# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  before_action :client_variables
  before_action :widgets_api_variables

  # GET / or GET /visible/widgets
  def create
    index_url = "#{@api_url}?#{@client_params}"
    response = RestClient.get(index_url, @authorization_hash)
    @widgets = ActiveSupport::JSON.decode(response.body)['data']['widgets']
  end
end