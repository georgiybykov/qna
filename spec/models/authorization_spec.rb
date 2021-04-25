# frozen_string_literal: true

describe Authorization, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user).touch(true) }

  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :uid }

  it { is_expected.to have_db_column(:provider).of_type(:string).with_options(null: false) }
  it { is_expected.to have_db_column(:uid).of_type(:string).with_options(null: false) }

  describe 'the uniqueness of the :uid scoped to :provider' do
    before do
      user = create(:user)

      create(:authorization, user: user)
    end

    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).case_insensitive }
  end
end
