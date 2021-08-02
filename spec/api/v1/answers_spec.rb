# frozen_string_literal: true

describe 'Answers API', type: :request, aggregate_failures: true do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  let(:access_token) { create(:access_token).token }

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET /api/v1/questions/:id/answers' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions/:id/answers'

    context 'when authorized' do
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let(:answer) { answers.last }

      let(:answer_response) { response_json[:answers].last }

      let(:params) do
        {
          access_token: access_token,
          question_id: question
        }
      end

      before { get "/api/v1/questions/#{question.id}/answers", params: params, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful
      end

      it 'returns the list of the answers for the question' do
        expect(response_json[:answers].count).to eq 2
      end

      it 'returns all public fields' do
        expect(answer_response[:id]).to eq answer.id
        expect(answer_response[:body]).to eq answer.body
        expect(answer_response[:best]).to eq false
        expect(answer_response[:question_id]).to eq question.id
        expect(answer_response[:created_at]).to eq answer.created_at.as_json
        expect(answer_response[:updated_at]).to eq answer.updated_at.as_json
      end

      it 'contains a user object' do
        expect(answer_response[:author]).to eq({
                                                 id: user.id,
                                                 email: user.email,
                                                 admin: false,
                                                 created_at: user.created_at.as_json,
                                                 updated_at: user.updated_at.as_json
                                               })
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers/:id' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions/:id/answers/:id'

    context 'when authorized' do
      let(:answer) { create(:answer, :with_file, question: question, user: user) }
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
      let(:comment) { comments.first }
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let(:link) { links.first }

      let(:answer_response) { response_json[:answer] }

      let(:params) do
        {
          access_token: access_token,
          id: answer,
          question_id: question
        }
      end

      before do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: params, headers: headers
      end

      it 'returns 200 response status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        expect(answer_response[:id]).to eq answer.id
        expect(answer_response[:body]).to eq answer.body
        expect(answer_response[:best]).to eq false
        expect(answer_response[:question_id]).to eq question.id
        expect(answer_response[:created_at]).to eq answer.created_at.as_json
        expect(answer_response[:updated_at]).to eq answer.updated_at.as_json
      end

      it 'contains nested comments' do
        expect(answer_response[:comments].first).to eq({
                                                         id: comment.id,
                                                         body: comment.body,
                                                         user_id: comment.user_id,
                                                         created_at: comment.created_at.as_json,
                                                         updated_at: comment.updated_at.as_json
                                                       })
      end

      it 'contains nested file URL\'s' do
        expect(answer_response[:files].first[:url]).to include('/second_file.txt')
      end

      it 'contains nested links' do
        expect(answer_response[:links].first).to eq({
                                                      id: link.id,
                                                      name: link.name,
                                                      url: link.url,
                                                      created_at: link.created_at.as_json,
                                                      updated_at: link.updated_at.as_json
                                                    })
      end

      it 'contains a user object' do
        expect(answer_response[:author]).to eq({
                                                 id: user.id,
                                                 email: user.email,
                                                 admin: false,
                                                 created_at: user.created_at.as_json,
                                                 updated_at: user.updated_at.as_json
                                               })
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    it_behaves_like 'API Unauthorized', :post, '/api/v1/questions/:id/answers'

    context 'when authorized' do
      context 'with valid params' do
        let(:params) do
          {
            access_token: access_token.token,
            answer: {
              body: 'It is Wednesday again, my dude!'
            }
          }
        end

        let(:another_user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }

        let(:answer_response) { response_json[:answer] }

        it 'returns 201 response status' do
          post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers

          expect(response.status).to eq 201
        end

        it 'saves a new answer to the database' do
          expect { post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers }
            .to change(question.answers, :count)
                  .by(1)
        end

        context 'and returns answer data in response' do
          before { post "/api/v1/questions/#{question.id}/answers", params: params, headers: headers }

          it 'returns all public fields' do
            expect(answer_response[:body]).to eq 'It is Wednesday again, my dude!'

            expect(answer_response).to have_key :id
            expect(answer_response).to have_key :created_at
            expect(answer_response).to have_key :updated_at
          end

          it 'contains a user object' do
            expect(answer_response[:author]).to eq({
                                                     id: another_user.id,
                                                     email: another_user.email,
                                                     admin: false,
                                                     created_at: another_user.created_at.as_json,
                                                     updated_at: another_user.reload.updated_at.as_json
                                                   })
          end
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          {
            access_token: access_token,
            answer: attributes_for(:answer, :invalid)
          }
        end

        before { post "/api/v1/questions/#{question.id}/answers", params: invalid_params, headers: headers }

        it 'returns 422 response status' do
          expect(response.status).to eq 422
        end

        it 'returns the response with errors hash' do
          expect(response_json).to have_key :errors
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions' do
    it_behaves_like 'API Unauthorized', :patch, '/api/v1/questions/:id/answers/:id'

    context 'when authorized' do
      let(:answer) { create(:answer, :with_file, :with_comment, :with_link, question: question, user: user) }

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      let(:answer_response) { response_json[:answer] }

      context 'with valid params' do
        let(:params) do
          {
            access_token: access_token.token,
            answer: {
              body: 'New Answer Body'
            }
          }
        end

        before { patch "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: params, headers: headers }

        it 'returns 200 response status' do
          expect(response.status).to eq 200
        end

        it 'updates the answer for the question and returns all public fields' do
          expect(answer_response[:id]).to eq answer.id
          expect(answer_response[:body]).to eq 'New Answer Body'
          expect(answer_response[:created_at]).to eq answer.created_at.as_json
          expect(answer_response[:updated_at]).to eq answer.reload.updated_at.as_json
        end

        it 'returns comments' do
          expect(answer_response[:comments].count).to eq 1
        end

        it 'returns files URL\'s' do
          expect(answer_response[:files].count).to eq 1
        end

        it 'returns links' do
          expect(answer_response[:links].count).to eq 1
        end
      end

      context 'with invalid params' do
        let(:invalid_params) do
          {
            access_token: access_token.token,
            answer: attributes_for(:answer, :invalid)
          }
        end

        before do
          patch "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: invalid_params, headers: headers
        end

        it 'returns 422 response status' do
          expect(response.status).to eq 422
        end

        it 'returns the response with errors hash' do
          expect(response_json).to have_key :errors
        end

        it 'does not update the answer' do
          expect(answer.reload.body).to include('AnswerBody-')
        end
      end

      context 'when the user is not the author of the answer' do
        let(:another_user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }

        let(:params) do
          {
            access_token: access_token.token,
            answer: {
              body: 'New Answer Body'
            }
          }
        end

        it 'does not update the question and responses with :forbidden status' do
          patch "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: params, headers: headers

          expect(response.status).to be 403

          expect(response_json).to eq({ message: 'You are not authorized to perform this action!' })
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id/answers/:id' do
    it_behaves_like 'API Unauthorized', :delete, '/api/v1/questions/:id/answers/:id'

    context 'when authorized' do
      let!(:answer) { create(:answer, question: question, user: user) }

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      let(:params) do
        { access_token: access_token.token }
      end

      let(:perform_action) do
        delete "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: params, headers: headers
      end

      context 'when the user is the author of the answer for the question' do
        it 'deletes the answer' do
          expect { perform_action }.to change(question.answers, :count).by(-1)
        end

        it 'returns 200 response status' do
          perform_action

          expect(response.status).to eq 200
        end

        it 'returns response with empty hash' do
          perform_action

          expect(response_json).to eq({})
        end
      end

      context 'when the user is not the author of the answer for the question' do
        let(:another_user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }

        it 'does not delete the answer for the question and responses with :forbidden status' do
          perform_action

          expect(response.status).to be 403

          expect(response_json).to eq({ message: 'You are not authorized to perform this action!' })
        end
      end
    end
  end
end
