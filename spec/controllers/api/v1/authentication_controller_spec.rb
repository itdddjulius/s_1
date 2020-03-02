# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do
  let(:user) { create(user_assigned) }

  context 'without an authenticated user' do
    describe 'POST /authentication/revoke' do
      it '302 - Redirected' do
        post :revoke
        expect(response.status).to eq(302)
      end
    end

    describe 'POST /authentication' do
      it '302 - Redirected' do
        post :create, params: {
          authentication: {
            email: 'anyelo@developer.com',
            password: '12345678'
          }
        }
        expect(response.status).to eq(302)
      end
    end
  end

  context 'with an authenticated user' do
    describe 'POST /authentication/revoke' do
      it '302 - Redirected' do
        post :revoke
        expect(response.status).to eq(302)
      end
    end

    describe 'POST /authentication' do
      it '302 - Redirected' do
        post :create, params: {
          authentication: {
            email: 'anyelo@developer.com',
            password: '12345678'
          }
        }
        expect(response.status).to eq(302)
      end
    end
  end
end
