# frozen_string_literal: true

require 'rails_helper'

describe Question, type: :model, aggregate_failures: true do
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
end
