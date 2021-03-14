# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def check_permissions(object)
    head(:forbidden) unless current_user.author?(object)
  end
end
