# frozen_string_literal: true

class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    SendNewAnswerNotificationService.new.call(answer: answer)
  end
end
