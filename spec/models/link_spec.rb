# frozen_string_literal: true

describe Link, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:question) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to have_db_column(:name).of_type(:string).with_options(limit: 50) }
  it { is_expected.to have_db_column(:url).of_type(:string) }
end
