# frozen_string_literal: true

shared_examples 'Not created object with invalid params' do
  context 'when authorized user tries to create object with invalid params' do
    let(:invalid_params) do
      {
        access_token: access_token,
        object => attributes_for(object, :invalid)
      }
    end

    it 'returns 422 response status' do
      perform_request(method, path, params: invalid_params, headers: headers)

      expect(response.status).to eq 422
    end

    it 'returns the response with errors hash' do
      perform_request(method, path, params: invalid_params, headers: headers)

      expect(response_json).to have_key :errors
    end

    it 'does not broadcast to the channel' do
      expect { perform_request(method, path, params: invalid_params, headers: headers) }
        .not_to broadcast_to channel
    end

    it 'does not enqueue background job' do
      expect { perform_request(method, path, params: invalid_params, headers: headers) }
        .not_to have_enqueued_job(background_job)
    end
  end
end
