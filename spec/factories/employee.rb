# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    name { 'Sr. Employee' }
    email { 'employee@runahr.com' }
    password { '12345678' }
  end
end
