# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    render json: request.env['omniauth.auth']
  end
end
