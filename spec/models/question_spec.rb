# frozen_string_literal: true

describe Question, type: :model, aggregate_failures: true do
  let(:question) { described_class.new }

  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to have_one(:reward).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_uniqueness_of :title }

  it { is_expected.to accept_nested_attributes_for(:reward) }

  it { is_expected.to have_db_column(:title).of_type(:text) }
  it { is_expected.to have_db_column(:body).of_type(:text) }

  it 'has many attached files' do
    expect(question.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob#perform_later' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
