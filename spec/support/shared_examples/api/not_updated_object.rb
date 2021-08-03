# frozen_string_literal: true

shared_examples 'Not updated object' do |type|
  context 'when authorized user tries to update object with invalid params' do
    let(:invalid_params) do
      {
        access_token: access_token.token,
        type => attributes_for(type, :invalid)
      }
    end

    before { perform_request(method, path, params: invalid_params, headers: headers) }

    it 'returns 422 response status' do
      expect(response.status).to eq 422
    end

    it 'returns the response with errors hash' do
      expect(response_json).to have_key :errors
    end

    it 'does not update the object' do
      case type
      when :question
        question.reload

        expect(question.title).to include('QuestionTitle-')
        expect(question.body).to eq('QuestionBody')
      when :answer
        expect(answer.reload.body).to include('AnswerBody-')
      end
    end
  end
end
