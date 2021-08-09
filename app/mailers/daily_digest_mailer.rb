# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.created_after(1.day.ago)
    @user_email = user.email

    mail to: user.email
  end
end
