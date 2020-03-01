# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AdministratorsController, type: :controller do
  let(:user) { create(user_assigned) }

  context 'without an authenticated user' do
    describe 'GET /api/v1/administrators' do
      it '401 - Unauthorized' do
        get :index
        expect(response.status).to eq(401)
      end
    end

    describe 'POST /api/v1/administrators' do
      it '401 - Unauthorized' do
        post :create
        expect(response.status).to eq(401)
      end
    end

    describe 'GET /api/v1/administrators/:id' do
      it '401 - Unauthorized' do
        post :show, params: { id: 1 }
        expect(response.status).to eq(401)
      end
    end

    describe 'UPDATE /api/v1/administrators/:id' do
      it '401 - Unauthorized' do
        patch :update, params: { id: 1 }
        expect(response.status).to eq(401)
      end
    end

    describe 'DELETE /api/v1/administrators/:id' do
      it '401 - Unauthorized' do
        delete :destroy, params: { id: 1 }
        expect(response.status).to eq(401)
      end
    end

    describe 'GET /api/v1/administrators/:administrator_id/employees' do
      it '401 - Unauthorized' do
        get :employees, params: { administrator_id: 1 }
        expect(response.status).to eq(401)
      end
    end

    describe 'GET /api/v1/administrators/:administrator_id/operations' do
      it '401 - Unauthorized' do
        get :operations, params: { administrator_id: 1 }
        expect(response.status).to eq(401)
      end
    end
  end

  context 'with an authenticated user' do
    let(:user_assigned) { :administrator }
    before do
      sign_in(user)
    end

    describe 'GET /api/v1/administrators' do
      before do
        mock = double(index?: true)

        expect(AdministratorPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      it '200 - OK' do
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe 'POST /api/v1/administrators' do
      context 'when administrator has been created successfully' do
        before do
          mock = double(create?: true)

          expect(AdministratorPolicy)
            .to receive(:new)
            .with(user: user)
            .once
            .and_return(mock)

          post :create, params: {
            administrator: {
              name: 'Sr. Admin',
              email: 'admin@gmail.com',
              position: 'RRHH',
              password: '12345678'
            }
          }
        end

        it '201 - CREATED' do
          expect(response.status).to eq(201)
        end

        it 'return an administrator object' do
          json_body = JSON.parse(response.body)
          expect(json_body.dig('data', 'type')).to eq('administrators')
        end
      end

      context 'when failures have occurred' do
        before do
          mock = double(create?: true)

          expect(AdministratorPolicy)
            .to receive(:new)
            .with(user: user)
            .once
            .and_return(mock)

          post :create, params: {
            administrator: {
              email: ''
            }
          }
        end

        it '422 - UNPROCESSABLE ENTITY' do
          expect(response.status).to eq(422)
        end
      end
    end

    describe 'GET /api/v1/administrators/:id' do
      before do
        mock = double(show?: true)

        expect(AdministratorPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      it '200 - OK' do
        get :show, params: { id: user.id }
        expect(response.status).to eq(200)
      end
    end

    describe 'UPDATE /api/v1/administrators/:id' do
      context 'when administrator has been updated successfully' do
        let(:user_assigned) { :administrator }

        before do
          mock = double(update?: true)

          expect(AdministratorPolicy)
            .to receive(:new)
            .with(user: user)
            .once
            .and_return(mock)

          patch :update, params: {
            id: user.id,
            administrator: {
              name: 'Sr. Admin Gonzales',
              email: 'gonzales@gmail.com',
              position: 'Supervisor',
              password: '12345678910'
            }
          }
        end

        it '200 - UPDATE' do
          expect(response.status).to eq(200)
        end

        it 'return an administrator object' do
          json_body = JSON.parse(response.body)
          expect(json_body.dig('data', 'type')).to eq('administrators')
        end
      end

      context 'when failures have occurred' do
        let(:user_assigned) { :administrator }
        before do
          mock = double(update?: true)

          expect(AdministratorPolicy)
            .to receive(:new)
            .with(user: user)
            .once
            .and_return(mock)

          patch :update, params: {
            id: user.id,
            administrator: {
              email: ''
            }
          }
        end

        it '422 - UNPROCESSABLE ENTITY' do
          expect(response.status).to eq(422)
        end
      end
    end

    describe 'DELETE /api/v1/administrators/:id' do
      let(:admin) { create(:administrator, :delete_admin) }

      before do
        mock = double(destroy?: true)

        expect(AdministratorPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      it '204 - NO CONTENT' do
        delete :destroy, params: { id: admin.id }
        expect(response.status).to eq(204)
      end

      context 'when you try to delete current_user' do
        it '403 - FORBIDDEN' do
          delete :destroy, params: { id: user.id }
          expect(response.status).to eq(403)
        end
      end
    end

    describe 'GET /api/v1/administrators/:administration_id/employees' do
      let(:user_assigned) { :administrator }
      before do
        mock = double(index?: true)

        expect(AdministratorPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      it '200 - OK' do
        get :employees, params: { administrator_id: user.id }
        expect(response.status).to eq(200)
      end
    end

    describe 'GET /api/v1/administrators/:administration_id/operations' do
      let(:user_assigned) { :administrator }
      before do
        mock = double(index?: true)

        expect(AdministratorPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      it '200 - OK' do
        get :operations, params: { administrator_id: user.id }
        expect(response.status).to eq(200)
      end
    end
  end
end
