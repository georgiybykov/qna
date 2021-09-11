# frozen_string_literal: true

class SubscriptionRepository
  # Finds the list of subscriptions for the
  # question by the answer without related
  # subscription of the answer's author, if any.
  #
  # @param answer [Answer]
  #
  # @return [Subscription::ActiveRecord_Relation]
  def subscriptions_for_question_by(answer)
    Subscription
      .includes(:user)
      .where(question_id: answer.question_id)
      .where.not(user_id: answer.user_id)
  end
end
