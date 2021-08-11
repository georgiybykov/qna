# frozen_string_literal: true

describe 'Questions API', type: :request, aggregate_failures: true do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  let(:access_token) { create(:access_token).token }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions'

    context 'when authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.last }
      let(:question_user) { question.user }

      let(:question_response) { response_json[:questions].last }

      before { get '/api/v1/questions', params: { access_token: access_token }, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful

        expect(response).to match_json_schema('v1/questions/questions')
      end

      it 'returns the list of the questions' do
        expect(response_json[:questions].count).to eq 2
      end

      it 'returns all public fields' do
        expect(question_response[:id]).to eq question.id
        expect(question_response[:title]).to eq question.title
        expect(question_response[:body]).to eq question.body
        expect(question_response[:created_at]).to eq question.created_at.as_json
        expect(question_response[:updated_at]).to eq question.updated_at.as_json
      end

      it 'contains short title' do
        expect(question_response[:short_title]).to eq question.title.truncate(7)
      end

      it 'contains a user object' do
        expect(question_response[:author]).to eq({
                                                   id: question_user.id,
                                                   email: question_user.email,
                                                   admin: false,
                                                   created_at: question_user.created_at.as_json,
                                                   updated_at: question_user.updated_at.as_json
                                                 })
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions/:id'

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, :with_file, user: user) }
      let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
      let(:comment) { comments.first }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:link) { links.first }

      let(:question_response) { response_json[:question] }

      let(:params) do
        {
          access_token: access_token,
          id: question
        }
      end

      before { get "/api/v1/questions/#{question.id}", params: params, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful

        expect(response).to match_json_schema('v1/questions/question')
      end

      it 'returns all public fields' do
        expect(question_response[:id]).to eq question.id
        expect(question_response[:title]).to eq question.title
        expect(question_response[:body]).to eq question.body
        expect(question_response[:created_at]).to eq question.created_at.as_json
        expect(question_response[:updated_at]).to eq question.updated_at.as_json
        expect(question_response[:short_title]).to eq question.title.truncate(7)
      end

      it 'contains nested comments' do
        expect(question_response[:comments].first).to eq({
                                                           id: comment.id,
                                                           body: comment.body,
                                                           user_id: comment.user_id,
                                                           created_at: comment.created_at.as_json,
                                                           updated_at: comment.updated_at.as_json
                                                         })
      end

      it 'contains nested file URL\'s' do
        expect(question_response[:files].first[:url]).to include('/first_file.txt')
      end

      it 'contains nested links' do
        expect(question_response[:links].first).to eq({
                                                        id: link.id,
                                                        name: link.name,
                                                        url: link.url,
                                                        created_at: link.created_at.as_json,
                                                        updated_at: link.updated_at.as_json
                                                      })
      end

      it 'contains a user object' do
        expect(question_response[:author]).to eq({
                                                   id: user.id,
                                                   email: user.email,
                                                   admin: false,
                                                   created_at: user.created_at.as_json,
                                                   updated_at: user.updated_at.as_json
                                                 })
      end
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Unauthorized', :post, '/api/v1/questions'

    context 'when authorized' do
      context 'with valid params' do
        let(:params) do
          {
            access_token: access_token.token,
            question: {
              title: 'First API Question',
              body: 'It is Wednesday, my dude!'
            }
          }
        end

        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        let(:question_response) { response_json[:question] }

        it_behaves_like 'Successfully created object', :question do
          let(:method) { :post }
          let(:path) { '/api/v1/questions' }
          let(:object) { Question }
        end

        it 'broadcasts to the `questions_list` channel' do
          expect { post '/api/v1/questions', params: params }
            .to broadcast_to('questions_list')
        end

        context 'and returns question data in response' do
          before { post '/api/v1/questions', params: params, headers: headers }

          it 'returns all public fields' do
            expect(question_response[:title]).to eq 'First API Question'
            expect(question_response[:body]).to eq 'It is Wednesday, my dude!'
            expect(question_response[:short_title]).to eq 'First API Question'.truncate(7)

            expect(question_response).to have_key :id
            expect(question_response).to have_key :created_at
            expect(question_response).to have_key :updated_at
          end

          it 'contains a user object' do
            expect(question_response[:author]).to eq({
                                                       id: user.id,
                                                       email: user.email,
                                                       admin: false,
                                                       created_at: user.created_at.as_json,
                                                       updated_at: user.reload.updated_at.as_json
                                                     })
          end
        end
      end

      it_behaves_like 'Not created object with invalid params' do
        let(:object) { :question }
        let(:method) { :post }
        let(:path) { '/api/v1/questions' }
        let(:channel) { 'questions_list' }
        let(:background_job) { 'no background job - mock' }
      end
    end
  end

  describe 'PATCH /api/v1/questions' do
    it_behaves_like 'API Unauthorized', :patch, '/api/v1/questions/:id'

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:question) { create(:question, :with_file, :with_comment, :with_link, user: user) }

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      let(:question_response) { response_json[:question] }

      context 'with valid params' do
        let(:params) do
          {
            access_token: access_token.token,
            question: {
              title: new_title,
              body: 'New Question Body'
            }
          }
        end

        let(:new_title) { 'New Question Title' }

        before { patch "/api/v1/questions/#{question.id}", params: params, headers: headers }

        it 'returns 200 response status' do
          expect(response.status).to eq 200

          expect(response).to match_json_schema('v1/questions/question')
        end

        it 'updates the question and returns all public fields' do
          expect(question_response[:id]).to eq question.id
          expect(question_response[:title]).to eq new_title
          expect(question_response[:body]).to eq 'New Question Body'
          expect(question_response[:created_at]).to eq question.created_at.as_json
          expect(question_response[:updated_at]).to eq question.reload.updated_at.as_json
        end

        it 'returns new short_title for the question' do
          expect(question_response[:short_title]).to eq new_title.truncate(7)
        end

        it 'returns comments' do
          expect(question_response[:comments].count).to eq 1
        end

        it 'returns files URL\'s' do
          expect(question_response[:files].count).to eq 1
        end

        it 'returns links' do
          expect(question_response[:links].count).to eq 1
        end
      end

      it_behaves_like 'Not updated object', :question do
        let(:method) { :patch }
        let(:path) { "/api/v1/questions/#{question.id}" }
      end

      it_behaves_like 'Not the author of the object' do
        let(:method) { :patch }
        let(:path) { "/api/v1/questions/#{question.id}" }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Unauthorized', :delete, '/api/v1/questions/:id'

    context 'when authorized' do
      let(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      let(:params) do
        { access_token: access_token.token }
      end

      let(:perform_action) { delete "/api/v1/questions/#{question.id}", params: params, headers: headers }

      context 'when the user is the author of the question' do
        it 'deletes the question' do
          expect { perform_action }.to change(Question, :count).by(-1)
        end

        it 'returns 200 response status' do
          perform_action

          expect(response.status).to eq 200

          expect(response_json).to eq({})
        end
      end

      it_behaves_like 'Not the author of the object' do
        let(:method) { :delete }
        let(:path) { "/api/v1/questions/#{question.id}" }
      end
    end
  end
end
