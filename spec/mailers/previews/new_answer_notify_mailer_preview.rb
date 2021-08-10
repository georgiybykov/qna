# frozen_string_literal: true

class NewAnswerNotifyPreview < ActionMailer::Preview
  def notify
    NewAnswerNotifyMailer.notify(FactoryBot.build_stubbed(:answer))
  end
end
