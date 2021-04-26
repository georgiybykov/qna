# frozen_string_literal: true

module OmniAuthMacros
  def mock_auth_hash(provider:, email:, hash_provider: provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      {
        provider: hash_provider,
        uid: '12345678',
        info: {
          email: email
        }
      }
    )
  end
end
