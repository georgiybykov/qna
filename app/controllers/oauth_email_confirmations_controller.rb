# frozen_string_literal: true

class OauthEmailConfirmationsController < ApplicationController
  skip_authorization_check

  def new; end

  def create
    user = find_or_create_user

    if user.persisted?
      user.send_confirmation_instructions

      redirect_to new_user_session_path, notice: 'Check your email to confirm registration!'
    else
      flash.now[:alert] = 'Please, enter valid email'

      render :new
    end
  end

  private

  def find_or_create_user
    email = confirmation_params[:email]

    User.find_or_create_by(email: email) do |user|
      user.email = email
      user.password = Devise.friendly_token[0, 20]

      user.skip_confirmation_notification!
    end
  end

  def confirmation_params
    params.permit(:email)
  end
end
