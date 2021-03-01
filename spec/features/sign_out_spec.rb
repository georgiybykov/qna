# frozen_string_literal: true

feature 'The user can sign out', %q{
  In order to close session
  As an authenticated user
  I would like to be able to sign out
}, type: :feature, aggregate_failures: true do

  given(:user) { create(:user) }

  scenario 'The registered user tries to sign out' do
    sign_in(user)
    visit root_path
    click_on 'Sign out'

    expect(page).to have_content('Signed out successfully.')
  end

  scenario 'The unregistered user tries to sign out' do
    visit root_path

    expect(page).to_not have_content 'Sign Out'
  end
end
