# frozen_string_literal: true

class DailyDigestMailerPreview < ActionMailer::Preview
  def digest
    DailyDigestMailer.digest(FactoryBot.build_stubbed(:user))
  end
end
