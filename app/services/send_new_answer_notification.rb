# frozen_string_literal: true

class SendNewAnswerNotification
  def initialize(subscription_repo = SubscriptionRepository.new)
    @subscription_repo = subscription_repo
  end

  def call(answer:)
    subscriptions = subscription_repo.subscriptions_for_question_by(answer)

    send_notifications(answer, subscriptions)
  end

  private

  attr_reader :subscription_repo

  def send_notifications(answer, subscriptions)
    subscriptions.find_each do |subscription|
      NewAnswerNotifyMailer
        .notify(answer, subscription.user)
        .deliver_later
    end
  end
end
