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

    trait :with_file do
      after :create do |answer|
        answer.files.attach(io: File.open(Rails.root.join('spec/fixtures/second_file.txt')),
                            filename: 'second_file.txt')
      end
    end

    trait :with_comment do
      transient do
        comment_user { user }
      end

      after :create do |answer, evaluator|
        create(:comment, commentable: answer, user: evaluator.comment_user)
      end
    end

    trait :with_link do
      after :create do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end
