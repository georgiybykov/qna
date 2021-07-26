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
      let(:question) { questions.last }
      let(:question_response) { response_json[:questions].last }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token }, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful
      end

      it 'returns the list of the questions' do
        expect(response_json[:questions].size).to eq 2
      end

      it 'returns all public fields' do
        expect(question_response[:id]).to eq question.id
        expect(question_response[:title]).to eq question.title
        expect(question_response[:body]).to eq question.body
        expect(question_response[:created_at]).to eq question.created_at.as_json
        expect(question_response[:updated_at]).to eq question.updated_at.as_json
      end

      it 'contains a user object' do
        expect(question_response[:user][:id]).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response[:short_title]).to eq question.title.truncate(7)
      end

      context 'when there are nested answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response[:answers].first }

        it 'returns the list of the answers' do
          expect(question_response[:answers].size).to eq 3
        end

        it 'returns all public fields' do
          expect(answer_response).to eq({
                                          id: answer.id,
                                          body: answer.body,
                                          best: false,
                                          question_id: question.id,
                                          user_id: answer.user_id,
                                          created_at: answer.created_at.as_json,
                                          updated_at: answer.updated_at.as_json
                                        })
        end
      end
    end
  end
end
