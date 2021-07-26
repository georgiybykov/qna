# frozen_string_literal: true

describe 'Profiles API', type: :request, aggregate_failures: true do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/profiles/me'

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id).token }

      before { get '/api/v1/profiles/me', params: { access_token: access_token }, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        expect(response_json).to eq({
                                      id: me.id,
                                      email: me.email,
                                      admin: false,
                                      created_at: me.created_at.as_json,
                                      updated_at: me.updated_at.as_json
                                    })
      end

      it 'does not return private fields' do
        expect(response_json).not_to have_key :password
        expect(response_json).not_to have_key :encrypted_password
      end
    end
  end
end
