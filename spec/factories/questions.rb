# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'QuestionTitle' }
    body { 'QuestionBody' }

    association :user

    trait :invalid do
      title { nil }
    end
  end
end
