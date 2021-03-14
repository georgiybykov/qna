# frozen_string_literal: true

module ApplicationHelper
  FLASH_MESSAGE_STYLE = { notice: 'success', alert: 'danger' }.freeze

  def greeting_in_header(user)
    user.email
  end

  def author_of?(user, object)
    user&.author?(object)
  end
end
