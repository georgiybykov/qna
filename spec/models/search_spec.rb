# frozen_string_literal: true

describe Search, type: :model do
  let(:search) { described_class.new(params) }

  let(:params) { {} }

  it { is_expected.to validate_presence_of :query }
  it { is_expected.to validate_presence_of :scope }

  it { is_expected.to validate_length_of(:query).is_at_least(3) }

  describe '#query' do
    let(:params) { { query: 'mock_query' } }

    it { expect(search.query).to eq('mock_query') }
  end

  describe '#scope' do
    let(:params) { { scope: 'mock_scope' } }

    it { expect(search.scope).to eq('mock_scope') }
  end
end
