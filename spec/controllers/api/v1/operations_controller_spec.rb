# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OperationsController, type: :controller do
  let(:user) { create(user_assigned) }

  context 'without an authenticated user' do
    let(:user_assigned) { :administrator }

    describe 'GET /api/v1/operations' do
      it '401 - Unauthorized' do
        get :index
        expect(response.status).to eq(401)
      end
    end

    describe 'POST /api/v1/operations/check_in' do
      it '401 - Unauthorized' do
        post :check_in
        expect(response.status).to eq(401)
      end
    end

    describe 'POST /api/v1/operations/check_out' do
      it '401 - Unauthorized' do
        post :check_out
        expect(response.status).to eq(401)
      end
    end

    describe 'GET /api/v1/operations/:id' do
      it '401 - Unauthorized' do
        get :show, params: { id: 1 }
        expect(response.status).to eq(401)
      end
    end
  end

  context 'with an authenticated user' do
    let(:user_assigned) { :administrator }
    before { sign_in(user) }

    describe 'GET /api/v1/operations' do
      before do
        mock = double(index?: true)

        expect(OperationPolicy)
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

    describe 'POST /api/v1/operations/check_in' do
      let(:user_assigned) { :administrator }
      let(:employee) { create(:employee) }

      before do
        mock = double(check?: true)

        expect(OperationPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      before do
        post :check_in, params: {
          operation: {
            employee_id: employee.id,
            note: 'Note here'
          }
        }
      end

      it '200 - OK' do
        expect(response.status).to eq(200)
      end
    end

    describe 'POST /api/v1/operations/check_out' do
      let(:user_assigned) { :administrator }
      let(:employee) { create(:employee) }

      before do
        mock = double(check?: true)

        expect(OperationPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      before do
        post :check_out, params: {
          operation: {
            employee_id: employee.id,
            note: 'Note here'
          }
        }
      end

      it '200 - OK' do
        expect(response.status).to eq(200)
      end
    end

    describe 'GET /api/v1/operations/:id' do
      let(:user_assigned) { :administrator }
      let(:employee) { create(:employee) }
      let(:operation) do
        create(:operation, administrator_id: user.id,
                           employee_id: employee.id)
      end

      before do
        mock = double(show?: true)

        expect(OperationPolicy)
          .to receive(:new)
          .with(user: user)
          .once
          .and_return(mock)
      end

      it '200 - OK' do
        get :show, params: { id: operation.id }
        expect(response.status).to eq(200)
      end
    end
  end
end
