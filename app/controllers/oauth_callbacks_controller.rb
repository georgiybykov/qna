# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_with_oauth
  end

  private

  def sign_in_with_oauth
    case Users::FindForOauth.new.call(auth_hash: auth_hash)
    in User => user
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: action_name.camelize) if is_navigational_format?
    in Symbol
      redirect_to root_path, alert: 'Something went wrong!'
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
