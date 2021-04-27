# frozen_string_literal: true

describe Users::FindForOauth, type: :service, aggregate_failures: true do
  subject(:result) { described_class.new.call(auth_hash: auth_hash) }

  let(:auth_hash) { mock_auth_hash(provider: :github, email: 'github-test@email.com') }

  context 'when the user had been authorized before with the same :provider and :uid' do
    let(:user) { create(:user) }

    before { create(:authorization, provider: 'github', uid: '12345678', user: user) }

    it 'returns the user for existing authorization' do
      expect(result).to eq(user)
    end
  end

  context 'when the user with the email form auth data exists' do
    let!(:user) { create(:user, email: 'github-test@email.com') }

    it 'creates the authorization for the user' do
      expect { result }.to change(user.authorizations, :count).by(1)
    end

    it 'does not create new user' do
      expect { result }.not_to change(User, :count)
    end

    it 'returns the user' do
      expect(result).to eq(user)
    end
  end

  context 'when the user does not exist' do
    it 'creates new user' do
      expect { result }.to change(User, :count).by(1)
    end

    it 'creates the authorization for the user' do
      expect { result }.to change(Authorization, :count).by(1)
    end

    it 'returns new user created with authentication data' do
      user = result

      expect(user.email).to eq(auth_hash[:info][:email])

      expect(user.confirmed?).to eq(true)
    end
  end

  context 'when the authorization data is invalid' do
    context 'and does not consist :provider info' do
      let(:auth_hash) { mock_auth_hash(provider: nil, email: 'github-test@email.com') }

      it 'does not create the user' do
        expect { result }.not_to change(User, :count)
      end

      it 'does not create the authorization for the user' do
        expect { result }.not_to change(Authorization, :count)
      end

      it 'returns the symbolic error :not_found_or_created' do
        expect(result).to eq(:not_found_or_created)
      end
    end

    context 'and does not consist :email info' do
      let(:auth_hash) { mock_auth_hash(provider: :github, email: nil) }

      it 'does not create the user' do
        expect { result }.not_to change(User, :count)
      end

      it 'does not create the authorization for the user' do
        expect { result }.not_to change(Authorization, :count)
      end

      it 'returns the symbolic error :no_email_provided' do
        expect(result).to eq(:no_email_provided)
      end
    end
  end
end
