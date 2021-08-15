# frozen_string_literal: true

class SendNewAnswerNotification
  def call(answer:)
    subscriptions(answer).find_each do |subscription|
      NewAnswerNotifyMailer
        .notify(answer, subscription.user)
        .deliver_later
    end
  end

  private

  def subscriptions(answer)
    Subscription
      .includes(:user)
      .where(question_id: answer.question_id)
      .where.not(user_id: answer.user_id)
  end
end
