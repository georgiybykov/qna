# frozen_string_literal: true

describe OauthCallbacksController, type: :controller, aggregate_failures: true do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Github' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash(
        provider: :github,
        email: 'github-test@email.com'
      )
    end

    context 'when the user exists' do
      let(:user) { create(:user, email: 'github-test@email.com') }

      before do
        create(:authorization, user: user)

        get :github
      end

      it 'logins the user' do
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user does not exists' do
      it 'logins created user' do
        get :github

        expect(controller.current_user.email).to eq('github-test@email.com')
      end

      it 'does not login user' do
        expect { get :github }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        get :github

        expect(response).to redirect_to root_path
      end
    end

    context 'when the auth data does not provide the user email' do
      before do
        request.env['omniauth.auth'] = mock_auth_hash(provider: :github, email: nil)

        get :github
      end

      it 'does not login the user' do
        expect(controller.current_user).to be_nil
      end

      it 'does not create new user' do
        expect { controller }.not_to change(User, :count)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to new_oauth_email_confirmation_path
      end
    end
  end

  describe 'Facebook' do
    before do
      request.env['omniauth.auth'] = mock_auth_hash(
        provider: :facebook,
        email: 'facebook-test@email.com'
      )
    end

    context 'when the user exists' do
      let(:user) { create(:user, email: 'facebook-test@email.com') }

      before do
        create(:authorization, user: user)

        get :facebook
      end

      it 'logins the user' do
        expect(controller.current_user).to eq(user)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when the user does not exists' do
      it 'logins created user' do
        get :facebook

        expect(controller.current_user.email).to eq('facebook-test@email.com')
      end

      it 'does not login user' do
        expect { get :facebook }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        get :facebook

        expect(response).to redirect_to root_path
      end
    end

    context 'when the auth data does not provide the user email' do
      before do
        request.env['omniauth.auth'] = mock_auth_hash(provider: :facebook, email: nil)

        get :facebook
      end

      it 'does not login the user' do
        expect(controller.current_user).to be_nil
      end

      it 'does not create new user' do
        expect { controller }.not_to change(User, :count)
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to new_oauth_email_confirmation_path
      end
    end
  end
end
