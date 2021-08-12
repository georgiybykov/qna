# frozen_string_literal: true

describe Subscription, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :question }

  it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
  it { is_expected.to have_db_column(:question_id).of_type(:integer).with_options(null: false) }

  describe 'the uniqueness of the user scoped to question' do
    before { create(:subscription) }

    it { is_expected.to validate_uniqueness_of(:user).scoped_to(:question_id) }
  end
end
