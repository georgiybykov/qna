# frozen_string_literal: true

describe Question, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }
end
