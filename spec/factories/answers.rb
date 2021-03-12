# frozen_string_literal: true

FactoryBot.define do
  sequence(:body) { |n| "AnswerBody-#{n}" }

  factory :answer do
    body { generate(:body) }
    best { false }

    association :question
    association :user

    trait :without_question do
      question { nil }
    end

    trait :invalid do
      body { nil }
    end
  end
end
