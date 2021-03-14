# frozen_string_literal: true

describe QuestionsController, type: :controller, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'renders the index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new answers for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

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

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question to the database' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Question, :count)
                .by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .not_to change(Question, :count)
      end

      it 'renders the new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes the question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' }, format: :js }

        question.reload

        expect(question.title).to eq('New title')
        expect(question.body).to eq('New body')
      end

      it 'renders the update view' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' }, format: :js }

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change the question' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }

        question.reload

        expect(question.title).to eq('QuestionTitle')
        expect(question.body).to eq('QuestionBody')
      end

      it 'renders the update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'when the user is the author of the question' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }
          .to change(Question, :count)
                .by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end

      it 'renders the destroy view (after xhr request)' do
        delete :destroy, xhr: true, params: { id: question }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when the user is not the author of the question' do
      before { login(user) }

      it 'does not delete the question and responses :forbidden' do
        expect { delete :destroy, params: { id: question } }
          .not_to change(Question, :count)

        expect(response.status).to be 403
      end
    end

    context 'when the user is the guest of the resource' do
      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }
          .not_to change(Question, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
