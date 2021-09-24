# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(
    Rails.application.credentials.admin_email || 'no-reply@qna.com',
    'QnA Admin'
  )

  layout 'mailer'
end
