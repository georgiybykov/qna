# frozen_string_literal: true

describe Comment, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to belong_to(:commentable).touch(true) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_db_column(:body).of_type(:text) }
end
