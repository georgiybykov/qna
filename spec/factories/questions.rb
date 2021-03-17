# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'QuestionTitle' }
    body { 'QuestionBody' }

    association :user

    trait :invalid do
      title { nil }
    end

    trait :with_file do
      after :create do |question|
        question.files.attach(io: File.open(Rails.root.join('spec/fixtures/first_file.txt')),
                              filename: 'first_file.txt')
      end
    end
  end
end
