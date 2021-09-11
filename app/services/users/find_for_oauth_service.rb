# frozen_string_literal: true

module Users
  class FindForOauthService
    # @param auth_hash [Hash]
    #
    # @return [<User, Symbol>]
    def call(auth_hash:)
      provider, uid, email = convert_args(auth_hash)

      authorization = Authorization.find_by(provider: provider, uid: uid.to_s)

      return authorization.user if authorization

      return :no_email_provided unless email

      find_or_create_user(provider, uid, email)
    end

    private

    def find_or_create_user(provider, uid, email)
      user = User.find_by(email: email)

      result = user

      ActiveRecord::Base.transaction do
        result ||= create_user(email)

        result.authorizations.create!(provider: provider, uid: uid)
      rescue StandardError
        result = :not_found_or_created

        raise ActiveRecord::Rollback
      end

      result
    end

    def create_user(email)
      password = Devise.friendly_token[0, 20]

      user = User.create!(email: email,
                          password: password,
                          password_confirmation: password)

      user.skip_confirmation!

      user
    end

    def convert_args(auth_hash)
      [
        auth_hash[:provider],
        auth_hash[:uid],
        auth_hash[:info][:email]
      ]
    end
  end
end
