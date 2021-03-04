# frozen_string_literal: true

feature 'The user can sign in', %q{
  In order to ask the questions
  As an unauthenticated user
  I would like to be able to sign in
}, type: :feature, aggregate_failures: true do

  given(:user) { create(:user) }

  scenario 'The registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'The unregistered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'unregistered@test.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
