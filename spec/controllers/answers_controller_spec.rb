# frozen_string_literal: true

describe AnswersController, type: :controller, aggregate_failures: true do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'renders the show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer, question_id: question } }

    it 'renders the edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer to the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }
          .to change(question.answers, :count)
                .by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }
          .not_to change(question.answers, :count)
      end

      it 're-renders the new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
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
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }

        answer.reload

        expect(answer.body).to eq('AnswerBody')
      end

      it 're-renders the edit view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template :edit
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer, question: question) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: answer } }
          .to change(question.answers, :count)
                .by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
