# frozen_string_literal: true

feature 'The user can sign up', %q{
  In order to register a new account
  As an unregistered user
  I would like to be able to sign up
}, type: :feature, aggregate_failures: true do

  background { visit new_user_registration_path }

  scenario 'The unregistered user tries to sign up with valid params' do
    sign_up(email: 'success-attempt@test.com',
            password: '123456',
            password_confirmation: '123456')

    expect(page).to have_content /A message with a confirmation link has been sent to your email address./
  end

  scenario 'The unregistered user tries to sign up with invalid Email' do
    sign_up(email: 'failure-attempt',
            password: '123456',
            password_confirmation: '123456')

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'The unregistered user tries to sign up with invalid password' do
    sign_up(email: 'failure-attempt@test.com',
            password: '123',
            password_confirmation: '123')

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
  end

  scenario 'The unregistered user tries to sign up with invalid password confirmation' do
    sign_up(email: 'failure-attempt@test.com',
            password: '123456',
            password_confirmation: '123')

    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end

  scenario 'The unregistered user tries to sign up without any params' do
    click_on 'Confirm'

    expect(page).to have_content 'Email can\'t be blank'
  end
end
