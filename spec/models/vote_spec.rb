# frozen_string_literal: true

describe Vote, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to belong_to(:votable).touch(true) }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :value }

  it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }
  it { is_expected.to validate_uniqueness_of(:user).scoped_to(%i[votable_id votable_type]) }

  it { is_expected.to have_db_column(:value).of_type(:integer) }
end
