# frozen_string_literal: true

describe User, type: :model, aggregate_failures: true do
  let(:user) { create(:user) }

  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:rewards).dependent(:nullify) }
  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, default: '') }

  describe '#author?' do
    subject(:result) { user.author?(object) }

    context 'when the current user is not an author of the `object`' do
      let(:object) { create(:question) }

      it { is_expected.to eq(false) }
    end

    context 'when the current user is an author of the `object`' do
      let(:object) { create(:answer, user: user) }

      it { is_expected.to eq(true) }
    end
  end
end
