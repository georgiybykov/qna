# frozen_string_literal: true

feature 'The user can sign in from provider', %q{
  In order to sign in to the resource
  As an unauthenticated user
  I would like to be able to use my another social network account
}, type: :feature, aggregate_failures: true do

  describe 'Sign in with Github' do
    background do
      mock_auth_hash(provider: :github, email: 'github-test@email.com')

      visit new_user_session_path
    end

    scenario 'when the guest tries to sign in' do
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    context 'when the user already has authorization with GitHub' do
      given(:user) { create(:user, email: 'github-test@email.com') }
      given(:authorization) { create(:authorization, user: user) }

      scenario 'and tries to sign in' do
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    scenario 'when there is an authentication error occurs' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Enter your account'
      expect(page).to have_content 'Sign in with GitHub'
    end

    scenario 'when the authentication data is invalid and does not contain :provider' do
      mock_auth_hash(provider: :github, email: 'github-test@email.com', hash_provider: nil)

      click_link 'Sign in with GitHub'

      expect(page).to have_content 'Something went wrong!'
    end

    context 'when the authentication data does not contain :email' do
      scenario 'asks the user about email to send confirmation instructions' do
        mock_auth_hash(provider: :github, email: nil)

        click_link 'Sign in with GitHub'

        fill_in 'E-mail', with: 'invalid'
        click_button 'Send'

        expect(page).to have_content 'Please, enter valid email'
      end

      scenario 'asks the user about email to send confirmation instructions' do
        mock_auth_hash(provider: :github, email: nil)

        click_link 'Sign in with GitHub'

        fill_in 'E-mail', with: 'github-test@email.com'
        click_button 'Send'

        expect(page).to have_content 'Check your email to confirm registration!'

        open_email('github-test@email.com')
        current_email.click_link 'Confirm my account'

        expect(page).to have_content 'Your email address has been successfully confirmed.'
      end
    end
  end

  describe 'Sign in with Facebook' do
    background do
      mock_auth_hash(provider: :facebook, email: 'facebook-test@email.com')

      visit new_user_session_path
    end

    scenario 'when the guest tries to sign in' do
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end

    context 'when the user already has authorization with Facebook' do
      given(:user) { create(:user, email: 'facebook-test@email.com') }
      given(:authorization) { create(:authorization, user: user) }

      scenario 'and tries to sign in' do
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account.'
      end
    end

    scenario 'when there is an authentication error occurs' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

      click_link 'Sign in with Facebook'

      expect(page).to have_content 'Enter your account'
      expect(page).to have_content 'Sign in with Facebook'
    end

    scenario 'when the authentication data is invalid and does not contain :provider' do
      mock_auth_hash(provider: :facebook, email: 'facebook-test@email.com', hash_provider: nil)

      click_link 'Sign in with Facebook'

      expect(page).to have_content 'Something went wrong!'
    end

    context 'when the authentication data does not contain :email' do
      scenario 'asks the user about email to send confirmation instructions' do
        mock_auth_hash(provider: :facebook, email: nil)

        click_link 'Sign in with Facebook'

        fill_in 'E-mail', with: 'invalid'
        click_button 'Send'

        expect(page).to have_content 'Please, enter valid email'
      end

      scenario 'asks the user about email to send confirmation instructions' do
        mock_auth_hash(provider: :facebook, email: nil)

        click_link 'Sign in with Facebook'

        fill_in 'E-mail', with: 'facebook-test@email.com'
        click_button 'Send'

        expect(page).to have_content 'Check your email to confirm registration!'

        open_email('facebook-test@email.com')
        current_email.click_link 'Confirm my account'

        expect(page).to have_content 'Your email address has been successfully confirmed.'
      end
    end
  end
end
