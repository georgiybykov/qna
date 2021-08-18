# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('admin@qna.com', 'QnA Admin')

  layout 'mailer'
end
