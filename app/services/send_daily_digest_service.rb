# frozen_string_literal: true

class SendDailyDigestService
  def call!
    return :new_questions_not_found unless new_questions_exist?

    send_daily_digest_to_users
  end

  private

  def new_questions_exist?
    Question.created_after(1.day.ago).count.positive?
  end

  def send_daily_digest_to_users
    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
