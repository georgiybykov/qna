# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'QuestionTitle' }
    body { 'QuestionBody' }

    trait :invalid do
      title { nil }
    end
  end
end
