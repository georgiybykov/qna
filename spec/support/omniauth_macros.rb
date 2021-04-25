# frozen_string_literal: true

module OmniAuthMacros
  def mock_auth_hash(provider:, email:)
    OmniAuth.config.mock_auth[provider || :github] = OmniAuth::AuthHash.new(
      {
        provider: provider,
        uid: '12345678',
        info: {
          email: email
        }
      }
    )
  end
end
