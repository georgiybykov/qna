# frozen_string_literal: true

describe SubscriptionsController, type: :controller, aggregate_failures: true do
  include_context 'with gon stores shared params'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

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
end
