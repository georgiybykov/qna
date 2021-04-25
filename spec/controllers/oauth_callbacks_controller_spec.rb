# frozen_string_literal: true

describe OauthCallbacksController, type: :controller, aggregate_failures: true do
  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = mock_auth_hash(provider: :github, email: 'github-test@email.com')
  end

  describe 'Github' do
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

        expect(response).to redirect_to(root_path)
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
        expect(response).to redirect_to root_path
      end
    end
  end
end
