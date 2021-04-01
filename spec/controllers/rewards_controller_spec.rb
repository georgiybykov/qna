# frozen_string_literal: true

describe RewardsController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:reward) { create(:reward, user: user, question: question) }

  let(:another_user) { create(:user) }

  describe 'GET #index' do
    context 'when the user has rewards' do
      before do
        login(user)

        get :index
      end

      it 'returns an array of the earned rewards' do
        expect(assigns(:rewards)).to eq([reward])
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'when the user does not have rewards' do
      before do
        login(another_user)

        get :index
      end

      it 'returns an empty array' do
        expect(assigns(:rewards)).to be_empty
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'when the guest tries to visit the page with the list of rewards' do
      before { get :index }

      it 'returns nil' do
        expect(assigns(:rewards)).to eq(nil)
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
