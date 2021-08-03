# frozen_string_literal: true

shared_examples 'Not the author of the object' do
  context 'when the user is not the author of the object' do
    let(:another_user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: another_user.id) }

    it 'does not make an action with the object and responses with :forbidden status' do
      perform_request method, path, params: { access_token: access_token.token }, headers: headers

      expect(response.status).to be 403

      expect(response_json).to eq({ message: 'You are not authorized to perform this action!' })
    end
  end
end
