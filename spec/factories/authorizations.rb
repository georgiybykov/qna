# frozen_string_literal: true

FactoryBot.define do
  factory :authorization do
    provider { 'example_provider' }
    uid { '12345678' }
    user { nil }
  end
end
