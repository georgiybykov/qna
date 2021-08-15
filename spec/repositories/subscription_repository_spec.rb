# frozen_string_literal: true

describe SubscriptionRepository, type: :repository, aggregate_failures: true do
  let(:repo) { described_class.new }

  describe '#subscriptions_for_question_by' do
    subject(:result) { repo.subscriptions_for_question_by(answer) }

    let(:user) { create(:user) }

    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: user) }

    let!(:first_subscription) { create(:subscription, question: question, user: create(:user)) }
    let!(:second_subscription) { create(:subscription, question: question, user: create(:user)) }

    before { create(:subscription, question: question, user: user) }

    it 'returns subscriptions without related subscription for the author of the answer' do
      expect(result.to_a).to eq([first_subscription, second_subscription])
    end
  end
end
