# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :fetch_shared_params

  rescue_from CanCan::AccessDenied do |exception|
    exception.default_message = 'You are not authorized to perform this action!'

    respond_to do |format|
      format.html do
        redirect_back fallback_location: request.fullpath,
                      alert: exception.message,
                      status: :forbidden
      end

      format.js do
        render 'shared/ajax_flash',
               locals: { flash_alert: exception.message },
               status: :forbidden
      end

      format.json { render json: {}, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def fetch_shared_params
    payload = {
      params: params.permit(:id),
      user_id: current_user&.id
    }

    gon.push(payload)
  end
end
