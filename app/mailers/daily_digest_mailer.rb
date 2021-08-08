# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = 'Hi'

    mail to: user.email
  end
end
