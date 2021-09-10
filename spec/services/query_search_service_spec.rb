# frozen_string_literal: true

describe QuerySearchService, type: :service, aggregate_failures: true do
  subject(:result) { described_class.new.call(search: search) }

  let(:search) { build(:search) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  context 'when scope is invalid' do
    let(:search) { build(:search, scope: nil) }

    it { is_expected.to eq('Something went wrong!') }
  end

  context 'when query is invalid' do
    context 'and the value is nil or empty' do
      let(:search) { build(:search, query: nil) }

      it { is_expected.to eq("Query can't be blank") }
    end

    context 'and the value is too short' do
      let(:search) { build(:search, query: 'xx') }

      it { is_expected.to eq('Query is too short (minimum is 3 characters)') }
    end
  end

  context 'when searches for all scopes' do
    it 'returns an array with all types of found models inside' do
      expect(ThinkingSphinx)
        .to receive(:search)
              .with(search.query, classes: [nil])
              .and_return([question, answer])
              .once

      expect(result).to be_an(Array)
    end
  end

  context 'when searches the one from the available scopes' do
    let(:search) { build(:search, scope: 'Question') }

    it 'returns an array with one type of models inside' do
      expect(ThinkingSphinx)
        .to receive(:search)
              .with(
                search.query,
                classes: [search.scope.classify.constantize]
              )
              .and_return([question])
              .once

      expect(result).to be_an(Array)
    end
  end
end
