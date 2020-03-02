# frozen_string_literal: true

module Api
  module V1
    # Authentication Controller
    class AuthenticationController < ApplicationController
      include Tokenable
      include Payloadable
      include ApiRoutable
      include ApiRequestable
      include Flashable
      include Permitable

      # revoke_authentication_index POST   /authentication/revoke(.:format)
      def revoke
        revoke_response = post(revoke_url, revoke_payload)
        if revoke_response
          flash_message(revoke_response)
          reset_session
        else
          flash[:error] = 'You can\'t go out. You are trapped'
        end

        redirect_back fallback_location: root_path
      end
      
      # authentication_index POST   /authentication(.:format) 
      def create
        login_response = post(oauth_token_url, auth_payload)
        flash_message(login_response)
        set_tokens(login_response)

        redirect_back fallback_location: root_path
      end
    end
  end
end