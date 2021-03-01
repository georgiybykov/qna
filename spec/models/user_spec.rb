# frozen_string_literal: true

describe User, type: :model do
  it { is_expected.to have_many(:questions).dependent(:nullify) }
  it { is_expected.to have_many(:answers).dependent(:nullify) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
end
