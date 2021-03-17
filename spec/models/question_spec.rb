# frozen_string_literal: true

describe Question, type: :model, aggregate_failures: true do
  let(:question) { described_class.new }

  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it 'has many attached files' do
    expect(question.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
