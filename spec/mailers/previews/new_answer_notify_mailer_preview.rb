# frozen_string_literal: true

class NewAnswerNotifyMailerPreview < ActionMailer::Preview
  def notify
    subscriber = FactoryBot.build_stubbed(:user)

    NewAnswerNotifyMailer.notify(FactoryBot.build_stubbed(:answer), subscriber)
  end
end
