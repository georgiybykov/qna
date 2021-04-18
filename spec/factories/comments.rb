# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    body { 'MyText' }
    user { nil }

    trait :invalid do
      body { nil }
    end
  end
end
