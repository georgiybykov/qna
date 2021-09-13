# frozen_string_literal: true

describe SearchesController, type: :controller, aggregate_failures: true do
  describe 'GET #index' do
    context 'when the query is provided', :elasticsearch do
      let(:question) { create(:question, body: 'search-query', user: user) }
      let(:answer) { create(:answer, body: 'search-query', question: question, user: user) }
      let!(:comment) { create(:comment, body: 'search-query', commentable: answer, user: user) }
      let(:user) { create(:user, email: 'search-query@test.com') }

      before do
        Question.__elasticsearch__.refresh_index!
        Answer.__elasticsearch__.refresh_index!
        Comment.__elasticsearch__.refresh_index!
        User.__elasticsearch__.refresh_index!
      end

      context 'and there are provided all scopes for searching' do
        let(:search_params) do
          { query: 'search-query', scope: 'All scopes' }
        end

        it 'assigns @search_results variable and renders index template' do
          get :index, params: { search: search_params }

          expect(response).to render_template :index

          expect(assigns(:search_results))
            .to contain_exactly(question, answer, comment, user)
        end
      end

      context 'and there is only one scope provided for searching' do
        let(:search_params) do
          { query: 'search-query', scope: 'Answer' }
        end

        it 'assigns @search_results variable and renders index template' do
          get :index, params: { search: search_params }

          expect(response).to render_template :index

          expect(assigns(:search_results))
            .to contain_exactly(answer)
        end
      end
    end

    context 'when query is not provided' do
      let(:search_params) do
        { query: nil, scope: 'All scopes' }
      end

      it 'redirects to root_path with corresponding message' do
        get :index, params: { search: search_params }

        expect(response).to redirect_to root_path

        expect(flash[:alert]).to match "Query can't be blank"
      end
    end

    context 'when the provided query is invalid' do
      let(:search_params) do
        { query: 'xx', scope: 'All scopes' }
      end

      it 'redirects to root_path with corresponding message' do
        get :index, params: { search: search_params }

        expect(response).to redirect_to root_path

        expect(flash[:alert]).to match 'Query is too short (minimum is 3 characters)'
      end
    end
  end
end
