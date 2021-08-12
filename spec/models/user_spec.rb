# frozen_string_literal: true

describe User, type: :model, aggregate_failures: true do
  let(:user) { create(:user) }

  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:rewards).dependent(:nullify) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, default: '') }
end
