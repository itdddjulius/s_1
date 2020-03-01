# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Operations::Checking, type: :sevices do
  let(:user) { create(:administrator) }
  let(:checking) { Operations::Checking.new(admin: user) }
  let(:employee) { create(:employee) }

  describe '#check_in' do
    it 'successfully' do
      check_obj = checking.register_in(employee, 'ready')
      expect(check_obj.status).to eq('in')
      expect(check_obj.note).to eq('ready')
    end
  end

  describe '#check_out' do
    it 'successfully' do
      check_obj = checking.register_out(employee, 'ready')
      expect(check_obj.status).to eq('out')
      expect(check_obj.note).to eq('ready')
    end
  end
end
