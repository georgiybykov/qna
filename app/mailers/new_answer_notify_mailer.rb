# frozen_string_literal: true

class NewAnswerNotifyMailer < ApplicationMailer
  def notify(answer)
    @answer = answer
    @question = answer.question
    @author_email = answer.user.email

    mail to: answer.question.user.email
  end
end
