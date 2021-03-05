# frozen_string_literal: true

module ApplicationHelper
  def greeting_in_header(user)
    user.email
  end
end
