# frozen_string_literal: true

describe 'Questions API', type: :request, aggregate_failures: true do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions'

    context 'when authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.last }
      let(:question_user) { question.user }

      let(:question_response) { response_json[:questions].last }

      before { get '/api/v1/questions', params: { access_token: access_token }, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful
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

  describe 'GET /api/v1/questions/{id}' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions/0'

    context 'when authorized' do
      let(:access_token) { create(:access_token).token }
      let(:user) { create(:user) }
      let(:question) { create(:question, :with_file, user: user) }
      let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
      let(:comment) { comments.first }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:link) { links.first }

      let(:question_response) { response_json[:question] }

      before do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token, id: question }, headers: headers
      end

      it 'returns 200 response status' do
        expect(response).to be_successful
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
end
