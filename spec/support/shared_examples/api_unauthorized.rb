# frozen_string_literal: true

shared_examples_for 'API Unauthorized' do
  context 'when unauthorized' do
    it 'returns 401 response status if there is not access_token' do
      perform_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end

    it 'returns 401 response status if access_token is invalid' do
      perform_request(method, api_path, params: { access_token: '1234' }, headers: headers)

      expect(response.status).to eq 401
    end
  end
end
