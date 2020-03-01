# frozen_string_literal: true

FactoryBot.define do
  factory :administrator do
    name { 'Sr. Admin' }
    email { 'admin@runahr.com' }
    password { '12345678' }

    trait :delete_admin do
      email { 'admin_delete@admin.com' }
    end
  end
end
