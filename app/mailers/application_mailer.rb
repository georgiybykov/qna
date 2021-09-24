# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV.fetch('ADMIN_EMAIL', 'qna-admin@test.com'), 'QnA Admin')

  layout 'mailer'
end
