# frozen_string_literal: true

describe SendNewAnswerNotification, type: :service do
  subject(:result) { described_class.new.call(answer: answer) }

  let(:user) { create(:user) }

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  let(:first_subscriber) { create(:user) }
  let(:second_subscriber) { create(:user) }

  let(:subscribers) { [first_subscriber, second_subscriber] }

  before do
    create(:subscription, question: question, user: user)

    create(:subscription, question: question, user: first_subscriber)
    create(:subscription, question: question, user: second_subscriber)
  end

  it 'sends new answer notifications to all subscribers' do
    subscribers.each do |subscriber|
      expect(NewAnswerNotifyMailer)
        .to receive(:notify)
              .with(answer, subscriber)
              .and_call_original
              .once
    end

    result
  end
end
