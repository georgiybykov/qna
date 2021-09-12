# frozen_string_literal: true

FactoryBot.define do
  factory :search do
    query { 'QuestionTitle' }
    scope { 'All scopes' }
  end
end
