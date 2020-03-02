# frozen_string_literal: true

module Api
  module V1
    # Widgets Controller
    class WidgetsController < ApplicationController
      include Tokenable
      include Payloadable
      include ApiRoutable
      include ApiRequestable
      include Flashable
      include Permitable

      # root_path GET / OR widgets_path GET    /visible/widgets(.:format)
      def index
        @widgets = request_widgets(visible_widgets_url)
      end

      # search_widgets GET    /visible/widgets/search(.:format)
      def search
        @widgets = request_widgets(search_widgets_url)
        render :index
      end

      # mine_widgets GET    /widgets/mine(.:format)
      def mine
        redirect_to root_path unless @current_user
        @widgets = request_widgets(my_widgets_url)
      end

      # POST   /widgets(.:format)
      def create
        widget_response = post(my_widgets_url, widget_payload)
        flash_message(widget_response)
        
        redirect_back fallback_location: root_path
      end

      # PATCH  /widgets/:id(.:format) OR PUT    /widgets/:id(.:format)
      def update
        update_widget_response = put(widget_url, widget_payload)
        flash_message(update_widget_response)
        
        redirect_back fallback_location: mine_widgets_path
      end

      # DELETE /widgets/:id(.:format)
      def destroy
        destroy_widget_response = delete(widget_url)
        flash_message(destroy_widget_response)
        
        redirect_back fallback_location: mine_widgets_path
      end

      private

      def request_widgets(url)
        get(url)&.data&.widgets
      end
    end
  end
end