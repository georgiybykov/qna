# frozen_string_literal: true

FactoryBot.define do
  sequence(:email) { |n| "user-#{n}@test.com" }

  factory :user do
    email { generate(:email) }
    password { '123456789' }

    after(:build, &:skip_confirmation_notification!)
    after(:create, &:confirm)

    trait :admin do
      admin { true }
    end
  end
end
