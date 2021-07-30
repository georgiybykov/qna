# frozen_string_literal: true

describe 'Answers API', type: :request, aggregate_failures: true do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/questions/{id}/answers' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/questions/0/answers'

    context 'when authorized' do
      let(:access_token) { create(:access_token).token }
      let(:user) { create(:user) }
      let(:another_user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 2, question: question, user: another_user) }
      let(:answer) { answers.last }

      let(:answer_response) { response_json[:answers].last }

      let(:params) do
        {
          access_token: access_token,
          id: question
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
        expect(answer_response[:user_id]).to eq another_user.id
        expect(answer_response[:created_at]).to eq answer.created_at.as_json
        expect(answer_response[:updated_at]).to eq answer.updated_at.as_json
      end
    end
  end
end
