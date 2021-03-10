# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def check_permissions(object)
    no_permissions unless current_user.author?(object)
  end

  def no_permissions
    raise ActionController::BadRequest, 'No permissions to access'
  end
end
