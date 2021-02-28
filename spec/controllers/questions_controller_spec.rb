# frozen_string_literal: true

describe QuestionsController, type: :controller, aggregate_failures: true do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'renders the index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders the show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login(user)

      get :new
    end

    it 'renders the new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before do
      login(user)

      get :edit, params: { id: question }
    end

    it 'renders the edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Question, :count)
                .by(1)
      end

      it 'redirects to show view' do
        post :create, params: { id: question }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .not_to change(Question, :count)
      end

      it 're-renders the new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes the question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }

        question.reload

        expect(question.title).to eq('New title')
        expect(question.body).to eq('New body')
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change the question' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }

        question.reload

        expect(question.title).to eq('QuestionTitle')
        expect(question.body).to eq('QuestionBody')
      end

      it 're-renders the edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }

        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }
        .to change(Question, :count)
              .by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }

      expect(response).to redirect_to question_path
    end
  end
end
