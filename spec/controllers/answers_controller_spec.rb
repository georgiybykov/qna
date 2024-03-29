# frozen_string_literal: true

describe AnswersController, type: :controller, aggregate_failures: true do
  include ActiveJob::TestHelper

  include_context 'with gon stores shared params'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
          .to change(question.answers, :count)
                .by(1)
      end

      it 'renders the create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(response).to render_template :create
      end

      it 'broadcasts to the `answers_for_page_with_question_ID` channel' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
          .to broadcast_to("answers_for_page_with_question_#{question.id}")
      end

      it 'gonifies the `user_id` value as expected' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(gon['user_id']).to eq(user.id)
      end

      it 'enqueues NewAnswerNotificationJob' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
          .to have_enqueued_job(NewAnswerNotificationJob)
                .on_queue('default')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          answer: attributes_for(:answer, :invalid),
          question_id: question
        }
      end

      it 'does not save the answer' do
        expect { post :create, params: invalid_params, format: :js }
          .not_to change(question.answers, :count)
      end

      it 'renders the create template' do
        post :create, params: invalid_params, format: :js

        expect(response).to render_template :create
      end

      it 'does not broadcast to the `answers_for_page_with_question_ID` channel' do
        expect { post :create, params: invalid_params, format: :js }
          .not_to broadcast_to("answers_for_page_with_question_#{question.id}")
      end

      it 'gonifies the `user_id` value as expected' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js

        expect(gon['user_id']).to eq(user.id)
      end

      it 'does not enqueue NewAnswerNotificationJob' do
        expect { post :create, params: invalid_params, format: :js }
          .not_to have_enqueued_job(NewAnswerNotificationJob)
      end
    end

    context 'when the user is not authenticated' do
      before { sign_out(user) }

      it 'gonifies the `user_id` value and it equals to `nil`' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(gon['user_id']).to eq(nil)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes the answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'renders the update view' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          id: answer,
          answer: attributes_for(:answer, :invalid)
        }
      end

      it 'does not change the answer' do
        expect { patch :update, params: invalid_params, format: :js }
          .not_to change(answer, :body)
      end

      it 'renders the update view' do
        patch :update, params: invalid_params, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'when the user is the author of the answer' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }
          .to change(Answer, :count)
                .by(-1)
      end

      it 'renders the destroy view' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when the user is not the author of the answer' do
      before { login(user) }

      it 'does not delete the question and responses :forbidden' do
        expect { delete :destroy, params: { id: answer }, format: :js }
          .not_to change(Answer, :count)

        expect(response.status).to be 403
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }
          .not_to change(Answer, :count)
      end

      it 'responses :unauthorized' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'

        expect(response.status).to be 401
      end
    end
  end

  describe 'PATCH #set_best' do
    let(:author) { create(:user) }
    let(:new_question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: new_question, user: author) }

    context 'when the user is the author of the question' do
      before { login(author) }

      it 'sets the answer to be the best' do
        patch :set_best, params: { id: answer }, format: :js

        answer.reload

        expect(answer).to be_best
      end

      it 'renders the `set_best` view' do
        patch :set_best, params: { id: answer }, format: :js

        expect(response).to render_template :set_best
      end
    end

    context 'when the user is not the author of the question' do
      let(:not_author) { create(:user) }

      before { login(not_author) }

      it 'does not set the answer to be the best and responses :forbidden' do
        patch :set_best, params: { id: answer, answer: { best: true } }, format: :js

        expect(answer.reload.best?).to eq(false)

        expect(response.status).to be 403
      end
    end

    context 'when the user is not authenticated' do
      it 'does not set the answer to be the best' do
        patch :set_best, params: { id: answer, answer: { best: true } }, format: :js

        expect(response.body).to have_content 'You need to sign in or sign up before continuing.'

        expect(response.status).to be 401
      end
    end
  end

  it_behaves_like 'voted'
  it_behaves_like 'commented'
end
