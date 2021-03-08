# frozen_string_literal: true

module ApplicationHelper
  FLASH_MESSAGE_STYLE = { notice: 'success', alert: 'danger' }.freeze

  def greeting_in_header(user)
    user.email
  end
end
