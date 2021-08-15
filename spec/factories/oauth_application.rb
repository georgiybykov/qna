# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { 'Test Application' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { SecureRandom.uuid }
    secret { SecureRandom.uuid }
    scopes { ['read write'] }
  end
end
