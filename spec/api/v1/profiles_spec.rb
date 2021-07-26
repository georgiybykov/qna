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
                                      user: {
                                        id: me.id,
                                        email: me.email,
                                        admin: false,
                                        created_at: me.created_at.as_json,
                                        updated_at: me.updated_at.as_json
                                      }
                                    })
      end

      it 'does not return private fields' do
        expect(response_json).not_to have_key :password
        expect(response_json).not_to have_key :encrypted_password
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Unauthorized', :get, '/api/v1/profiles'

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id).token }

      let!(:users) { create_list(:user, 2) }
      let(:first_user) { users.first }
      let(:second_user) { users.last }

      let(:response_users_list) { response_json[:users] }

      before { get '/api/v1/profiles', params: { access_token: access_token }, headers: headers }

      it 'returns 200 response status' do
        expect(response).to be_successful
      end

      it 'returns the list of all users except authenticated one' do
        expect(response_users_list.size).to eq 2

        expect(response_users_list.pluck(:id).include?(me.id)).to eq false
      end

      it 'returns all public fields' do
        expect(response_users_list.first).to eq(
          {
            id: first_user.id,
            email: first_user.email,
            admin: false,
            created_at: first_user.created_at.as_json,
            updated_at: first_user.updated_at.as_json
          }
        )
      end

      it 'does not return private fields' do
        expect(response_users_list.first).not_to have_key :password
        expect(response_users_list.first).not_to have_key :encrypted_password
      end
    end
  end
end
