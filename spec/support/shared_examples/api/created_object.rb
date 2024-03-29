# frozen_string_literal: true

shared_examples 'Successfully created object' do |type|
  context 'when authorized user tries to create object with valid params' do
    it 'returns 201 response status' do
      perform_request method, path, params: params, headers: headers

      expect(response.status).to eq 201

      expect(response).to match_json_schema("v1/#{type.to_s.pluralize}/#{type}")
    end

    it 'saves a new answer to the database' do
      expect { perform_request method, path, params: params, headers: headers }
        .to change(object, :count)
              .by(1)
    end
  end
end
