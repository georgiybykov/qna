# frozen_string_literal: true

describe Reward, type: :model, aggregate_failures: true do
  let(:reward) { described_class.new }

  it { is_expected.to belong_to(:question).touch(true) }
  it { is_expected.to belong_to(:user).optional(true).touch(true) }

  it { is_expected.to validate_presence_of :title }

  it { is_expected.to have_db_column(:title).of_type(:string).with_options(limit: 50) }

  it 'has one attached file' do
    expect(reward.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
