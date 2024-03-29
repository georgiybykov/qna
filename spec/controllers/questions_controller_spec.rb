# frozen_string_literal: true

describe QuestionsController, type: :controller, aggregate_failures: true do
  include_context 'with gon stores shared params'

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    before { get :index }

    it 'renders the index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'assigns a new answers for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for the answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
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

    it 'assigns a new Question for @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link for the question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
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

      it 'subscribes the author of the question for updates' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to change(Subscription, :count)
                .by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end

      it 'broadcasts to the `questions_list` channel' do
        expect { post :create, params: { question: attributes_for(:question) } }
          .to broadcast_to('questions_list')
      end

      it 'gonifies the `user_id` value as expected' do
        post :create, params: { question: attributes_for(:question) }

        expect(gon['user_id']).to eq(user.id)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .not_to change(Question, :count)
      end

      it 'does not subscribe the author of the question for updates' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .not_to change(Subscription, :count)
      end

      it 'renders the new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end

      it 'does not broadcast to the `questions_list` channel' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }
          .not_to broadcast_to('questions_list')
      end

      it 'gonifies the values as expected' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(gon['user_id']).to eq(user.id)
      end
    end

    context 'when the user is not authenticated' do
      before { sign_out(user) }

      it 'gonifies the `user_id` value and it equals to `nil`' do
        post :create, params: { question: attributes_for(:question) }

        expect(gon['user_id']).to eq(nil)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question) }
    let(:question_params) { { title: 'New title', body: 'New body' } }
    let(:invalid_params) { attributes_for(:question, :invalid) }

    context 'when the user is the author of the question' do
      before { login(question.user) }

      context 'with valid attributes' do
        it 'changes the question attributes' do
          patch :update, params: { id: question, question: question_params }, format: :js

          question.reload

          expect(question.title).to eq('New title')
          expect(question.body).to eq('New body')
        end

        it 'renders the update view' do
          patch :update, params: { id: question, question: question_params }, format: :js

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change the question' do
          patch :update, params: { id: question, question: invalid_params }, format: :js

          question.reload

          expect(question.title).to include('QuestionTitle-')
          expect(question.body).to eq('QuestionBody')
        end

        it 'renders the update view' do
          patch :update, params: { id: question, question: invalid_params }, format: :js

          expect(response).to render_template :update
        end
      end
    end

    context 'when the user is not the author of the question' do
      before { login(user) }

      it 'does not update the question and responses with :forbidden status' do
        patch :update, params: { id: question, question: question_params }, format: :js

        expect(response.status).to be 403
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

      it 'does not delete the question and responses with :forbidden status' do
        expect { delete :destroy, params: { id: question } }
          .not_to change(Question, :count)

        expect(response.status).to be 403

        expect(flash[:alert]).to match 'You are not authorized to perform this action!'
      end

      it 'does not delete the question and responses with :forbidden status (JS format)' do
        expect { delete :destroy, xhr: true, params: { id: question }, format: :js }
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

  it_behaves_like 'voted'
  it_behaves_like 'commented'
end
