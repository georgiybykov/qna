# frozen_string_literal: true

describe OauthEmailConfirmationsController, type: :controller, aggregate_failures: true do
  describe 'GET #new' do
    before { get :new }

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'when the user already has registration' do
      let!(:user) { create(:user) }

      it 'does not create new user record to the database' do
        expect { post :create, params: { email: user.email } }.not_to change(User, :count)
      end

      it 'redirects to new session path' do
        post :create, params: { email: user.email }

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when the user does not have registration yet' do
      it 'saves new user record to the database' do
        expect { post :create, params: { email: 'test-email@mail.com' } }
          .to change(User, :count)
                .by(1)
      end

      it 'redirects to new session path' do
        post :create, params: { email: 'test-email@mail.com' }

        expect(response).to redirect_to new_user_session_path
      end

      it 'sends confirmation instructions to the email of the user' do
        post :create, params: { email: 'test-email@mail.com' }

        new_user = User.first

        expect(new_user.confirmation_sent_at_was.today?).to eq(true)
        expect(new_user.email).to eq('test-email@mail.com')
      end
    end

    context 'when the email is invalid' do
      it 'does not create new user record to the database' do
        expect { post :create, params: { email: 'invalid' } }.not_to change(User, :count)
      end

      it 'renders the new view' do
        post :create, params: { email: 'invalid' }

        expect(response).to render_template :new
      end
    end
  end
end
