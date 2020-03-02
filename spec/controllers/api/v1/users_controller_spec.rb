# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  context 'without an authenticated user' do
    describe 'POST /users' do
      it '302 - Redirected' do
        post :create, params: {
          registration: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john@doe.com',
            password: '12345678'
          }
        }
        expect(response.status).to eq(302)
      end
    end

    describe 'GET /users/:id' do
      it '302 - Redirected' do
        get :show, params: { id: 1 }
        expect(response.status).to eq(302)
      end
    end

    describe 'GET /users/me' do
      it '302 - Redirected' do
        get :me
        expect(response.status).to eq(302)
      end
    end

    describe 'UPDATE /users/update_my_profile' do
      it '302 - Redirected' do
        patch :update_my_profile, params: {
          user: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'john@doe.com',
            password: '12345678',
            image_url: 'image_url.png'
          }
        }
        expect(response.status).to eq(302)
      end
    end
  end

  context 'with an authenticated user' do
    describe 'POST /users' do
      context 'when user is created successfully' do
        before do
          post :create, params: {
            registration: {
              first_name: 'Anyelo',
              last_name: 'Petit',
              email: 'anyelo@developer.com',
              password: '12345678'
            }
          }
        end

        it '302 - Redirected' do
          expect(response.status).to eq(302)
        end
      end

      context 'when failures have occurred' do
        before do
          post :create, params: {
            registration: {
              email: ''
            }
          }
        end

        it '302 - Redirected' do
          expect(response.status).to eq(302)
        end
      end
    end

    describe 'GET /users/:id' do
      it '302 - Redirected' do
        get :show, params: { id: 1 }
        expect(response.status).to eq(302)
      end
    end
  end
end
