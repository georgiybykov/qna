# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'E-mail', with: user.email
    fill_in 'Password', with: user.password

    within('.actions') { click_on 'Sign in' }
  end

  def sign_up(email:, password:, password_confirmation:)
    fill_in 'E-mail', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation
    click_on 'Confirm'
  end
end
