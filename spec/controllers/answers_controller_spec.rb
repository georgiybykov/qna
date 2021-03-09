# frozen_string_literal: true

describe AnswersController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }
          .to change(question.answers, :count)
                .by(1)
      end

      it 'renders the create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        end
          .not_to change(question.answers, :count)
      end

      it 'renders the create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes the answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' }, format: :js }

        answer.reload

        expect(answer.body).to eq 'New body'
      end

      it 'renders the update view' do
        patch :update, params: { id: answer, answer: { body: 'New body' }, format: :js }

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change the answer' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        end.not_to change(answer, :body)
      end

      it 'renders the update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'when the user is the author of the answer' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }
          .to change(Answer, :count)
                .by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when the user is not the author of the answer' do
      before { login(user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }
          .not_to change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to answer.question
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }
          .not_to change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
