# frozen_string_literal: true

class NewAnswerNotifyMailer < ApplicationMailer
  def notify(answer, subscriber)
    @answer = answer
    @question = answer.question
    @author_email = answer.user.email

    mail to: subscriber.email
  end
end
