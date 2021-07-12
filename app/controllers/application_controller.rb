# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :fetch_shared_params

  check_authorization unless: :devise_controller?

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

      format.json { render json: { message: exception.message }, status: :forbidden }
    end
  end

  private

  def fetch_shared_params
    payload = {
      params: params.permit(:id),
      user_id: current_user&.id
    }

    gon.push(payload)
  end

  # This method will return ApplicationController.renderer with
  # Warden::Proxy instance added to the default environment hash.
  def controller_renderer
    ApplicationController.renderer.tap do |default_renderer|
      default_env = default_renderer.instance_variable_get(:@env)
      env_with_warden = default_env.merge('warden' => warden)
      default_renderer.instance_variable_set(:@env, env_with_warden)
    end
  end
end
