# frozen_string_literal: true

describe SendNewAnswerNotification, type: :service, aggregate_failures: true do
  subject(:result) { service.call(answer: answer) }

  let(:service) { described_class.new(subscription_repo) }

  let(:subscription_repo) do
    instance_double(::SubscriptionRepository, subscriptions_for_question_by: subscriptions)
  end

  let(:subscriptions) { Subscription.where(question_id: question.id) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  before do
    create(:subscription, question: question, user: create(:user))
    create(:subscription, question: question, user: create(:user))
  end

  it 'sends notification to all subscribers except the author of the answer' do
    subscriptions.each do |subscription|
      expect(NewAnswerNotifyMailer)
        .to receive(:notify)
              .with(answer, subscription.user)
              .and_call_original
              .once
    end

    result
  end
end
