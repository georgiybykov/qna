# frozen_string_literal: true

feature 'The user can sign in', %q{
  In order to ask the questions
  As an unauthenticated user
  I would like to be able to sign in
}, type: :feature do

  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'The registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'The unregistered user tries to sign in' do
    fill_in 'Email', with: 'unregistered@test.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end