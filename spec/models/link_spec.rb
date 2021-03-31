# frozen_string_literal: true

describe Link, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:linkable).touch(true) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to allow_values('http://example.com', 'https://example.com', 'ftp://example.com').for(:url) }
  it { is_expected.not_to allow_values('example.com', 'example').for(:url) }

  it { is_expected.to have_db_column(:name).of_type(:string).with_options(limit: 50) }
  it { is_expected.to have_db_column(:url).of_type(:string) }
end
