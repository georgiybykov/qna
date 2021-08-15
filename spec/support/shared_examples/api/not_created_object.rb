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

    it 'does not save a new record to the database' do
      expect { perform_request method, path, params: invalid_params, headers: headers }
        .not_to change(object.to_s.classify.constantize, :count)
    end

    it 'does not subscribe the author of the question for updates' do
      expect { perform_request method, path, params: invalid_params, headers: headers }
        .not_to change(Subscription, :count)
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
