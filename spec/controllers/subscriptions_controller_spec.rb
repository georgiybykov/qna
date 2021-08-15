# frozen_string_literal: true

describe SubscriptionsController, type: :controller, aggregate_failures: true do
  include_context 'with gon stores shared params'

  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new subscription to the database' do
        expect { post :create, params: { question_id: question }, format: :js }
          .to change(question.subscriptions, :count)
                .by(1)
      end

      it 'renders the create template' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'when the user is not authenticated' do
      before { sign_out(user) }

      it 'gonifies the `user_id` value and it equals to `nil`' do
        post :create, params: { question_id: question }, format: :js

        expect(gon['user_id']).to eq(nil)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:subscription) { question.subscriptions.first }

    context 'when the user is the owner of the subscription' do
      before { login(subscription.user) }

      it 'deletes the subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }
          .to change(Subscription, :count)
                .by(-1)
      end

      it 'renders the destroy view' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when the user is not the owner of the subscription' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it 'does not delete the subscription and responses :forbidden' do
        expect { delete :destroy, params: { id: subscription }, format: :js }
          .not_to change(Subscription, :count)

        expect(response.status).to be 403
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not delete the subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }
          .not_to change(Subscription, :count)
      end

      it 'responses :unauthorized' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'

        expect(response.status).to be 401
      end
    end
  end
end
