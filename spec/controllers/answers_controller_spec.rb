# frozen_string_literal: true

describe AnswersController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

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
      it 'saves a new answers to the database' do
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
      it 'does not save the answers' do
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
      it 'changes the answers attributes' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }

        answer.reload

        expect(answer.body).to eq('New body')
      end

      it 'redirects to updated answers' do
        patch :update, params: { id: answer, answer: { body: 'New body' } }

        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      it 'does not change the answers' do
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

    context 'when the user is the author of the answers' do
      before { login(answer.user) }

      it 'deletes the answers' do
        expect { delete :destroy, params: { id: answer } }
          .to change(Answer, :count)
                .by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'when the user is not the author of the answers' do
      before { login(user) }

      it 'does not delete the answers' do
        expect { delete :destroy, params: { id: answer } }
          .not_to change(Answer, :count)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to answer.question
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not delete the answers' do
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
