# frozen_string_literal: true

describe 'Questions API', type: :request, aggregate_failures: true do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/questions' do
    context 'when unauthorized' do
      it 'returns 401 response status if there is not access_token' do
        get '/api/v1/questions', headers: headers

        expect(response.status).to eq 401
      end

      it 'returns 401 response status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '1234' }, headers: headers

        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token).token }
      let!(:questions) { create_list(:question, 2) }
      let(:first_question) { questions.first }

      before { get '/api/v1/questions', params: { access_token: access_token }, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful
      end

      it 'returns the list of the questions' do
        expect(response_json.size).to eq 2
      end

      it 'returns all public fields' do
        expect(response_json.first).to eq({
                                            id: first_question.id,
                                            title: first_question.title,
                                            body: first_question.body,
                                            user_id: first_question.user_id,
                                            created_at: first_question.created_at.as_json,
                                            updated_at: first_question.updated_at.as_json
                                          })
      end
    end
  end
end
