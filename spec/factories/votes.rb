# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    value { 1 }
    user { nil }
  end
end
