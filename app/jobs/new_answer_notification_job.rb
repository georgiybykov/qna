# frozen_string_literal: true

class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SendNewAnswerNotification.new.call(answer: answer)
  end
end
