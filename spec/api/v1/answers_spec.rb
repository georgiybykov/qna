# frozen_string_literal: true

describe 'Answers API', type: :request, aggregate_failures: true do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

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

      before do
        get "/api/v1/questions/#{question.id}/answers", params: params, headers: headers
      end

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
end
