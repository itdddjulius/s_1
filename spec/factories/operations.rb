# frozen_string_literal: true

FactoryBot.define do
  factory :operation do
    status { 1 }
    employee_id { 1 }
    administrator_id { 1 }
    note { 'note' }

    trait :in do
      status { 0 }
    end

    trait :out do
      status { 1 }
    end
  end
end
