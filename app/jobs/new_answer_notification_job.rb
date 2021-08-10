# frozen_string_literal: true

class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotifyMailer.notify(answer).deliver_later
  end
end
