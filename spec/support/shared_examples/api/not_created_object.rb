# frozen_string_literal: true

shared_examples 'Not created object with invalid params' do
  context 'when authorized user tries to create object with invalid params' do
    let(:invalid_params) do
      {
        access_token: access_token,
        object => attributes_for(object, :invalid)
      }
    end

    before { perform_request(method, path, params: invalid_params, headers: headers) }

    it 'returns 422 response status' do
      expect(response.status).to eq 422
    end

    it 'returns the response with errors hash' do
      expect(response_json).to have_key :errors
    end
  end
end
