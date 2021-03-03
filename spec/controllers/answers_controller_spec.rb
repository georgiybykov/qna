# frozen_string_literal: true

describe AnswersController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'renders the show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    before do
      login(user)

      get :edit, params: { id: answer, question_id: question }
    end

    it 'renders the edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count)
                .by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }
          .not_to change(question.answers, :count)
      end

      it 're-renders the new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes the answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }

        answer.reload

        expect(answer.body).to eq('New body')
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }

        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      it 'does not change the answer' do
        answer_body = answer.body

        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }

        answer.reload

        expect(answer.body).to eq(answer_body)
      end

      it 're-renders the edit view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template :edit
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
