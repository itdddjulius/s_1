# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WidgetsController, type: :controller do
  context 'without an authenticated user' do
    describe 'GET /widgets' do
      it '200 - OK' do
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe 'GET /widgets/search' do
      it '200 - OK' do
        get :search, params: {
          client_id: Rails.application.secrets.client_id,
          client_secret: Rails.application.secrets.client_secret,
          term: 'widget'
        }
        expect(response.status).to eq(200)
      end
    end

    describe 'GET /widgets/mine' do
      it '302 - Redirected' do
        get :mine
        expect(response.status).to eq(302)
      end
    end
  end

  context 'with an authenticated user' do
    describe 'GET /widgets' do
      it '200 - OK' do
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe 'GET /widgets/search' do
      it '200 - OK' do
        get :search, params: {
          client_id: Rails.application.secrets.client_id,
          client_secret: Rails.application.secrets.client_secret,
          term: 'widget'
        }
        expect(response.status).to eq(200)
      end
    end

    describe 'GET /widgets/mine' do
      it '302 - Redirected' do
        get :mine
        expect(response.status).to eq(302)
      end
    end
  end
end
