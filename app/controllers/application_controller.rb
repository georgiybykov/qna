# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :fetch_shared_params

  private

  def fetch_shared_params
    payload = {
      params: params.permit(:id),
      user_id: current_user&.id
    }

    gon.push(payload)
  end

  def check_permissions(object)
    head(:forbidden) unless current_user.author?(object)
  end
end
