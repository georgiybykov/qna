# frozen_string_literal: true

describe QuerySearchService, type: :service, aggregate_failures: true do
  subject(:result) { described_class.new.call(search: search) }

  let(:search) { build(:search) }

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

  context 'when everything is OK', :elasticsearch do
    let(:question) { create(:question, body: 'search-query', user: user) }
    let(:answer) { create(:answer, body: 'search-query', question: question, user: user) }
    let!(:comment) { create(:comment, body: 'search-query', commentable: answer, user: user) }
    let(:user) { create(:user, email: 'search-query@test.com') }

    before do
      Question.__elasticsearch__.refresh_index!
      Answer.__elasticsearch__.refresh_index!
      Comment.__elasticsearch__.refresh_index!
      User.__elasticsearch__.refresh_index!
    end

    context 'and searches for all scopes' do
      let(:search) { build(:search, query: 'search-query', scope: 'All scopes') }

      it 'returns an array with all types of found models inside' do
        expect(result).to contain_exactly(question, answer, comment, user)
      end
    end

    context 'and searches the one from the available scopes' do
      let(:search) { build(:search, query: 'search-query', scope: 'Question') }

      it 'returns an array with one type of models inside' do
        expect(result).to eq([question])
      end
    end
  end
end
