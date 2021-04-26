# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with_oauth
  end

  def facebook
    sign_in_with_oauth
  end

  private

  def sign_in_with_oauth
    case Users::FindForOauth.new.call(auth_hash: auth_hash)
    in User => user
      sign_in_and_redirect(user, event: :authentication)

      set_flash_message(:notice, :success, kind: action_name.camelize) if is_navigational_format?
    in :no_email_provided
      session["devise.#{action_name}_data"] = request.env['omniauth.auth'].except('extra')

      redirect_to new_oauth_email_confirmation_path
    in :not_found_or_created
      redirect_to root_path, alert: 'Something went wrong!'
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
