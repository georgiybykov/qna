# frozen_string_literal: true

describe Answer, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to belong_to(:question).touch(true) }

  it { is_expected.to validate_presence_of :body }
end
