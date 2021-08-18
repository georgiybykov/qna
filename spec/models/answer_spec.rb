# frozen_string_literal: true

describe Answer, type: :model, aggregate_failures: true do
  include ActiveJob::TestHelper

  let(:answer) { described_class.new }

  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to belong_to(:question).touch(true) }
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_db_column(:body).of_type(:text).with_options(null: false) }
  it { is_expected.to have_db_column(:best).of_type(:boolean).with_options(null: false, default: false) }

  it 'has many attached files' do
    expect(answer.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#default_scope(sort by best)' do
    let(:question) { create(:question) }
    let(:first_answer) { create(:answer, question: question) }
    let(:second_answer) { create(:answer, question: question) }
    let(:best_answer) { create(:answer, best: true, question: question) }

    it 'returns the ordered list of answers by the best one first and created ASC the next ones' do
      expect(question.answers).to eq [best_answer, first_answer, second_answer]
    end
  end

  describe '#mark_as_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:first_answer) { create(:answer, question: question, user: user) }
    let!(:second_answer) { create(:answer, question: question, user: user) }

    before { create(:reward, question: question) }

    it 'sets the answer to be the best' do
      first_answer.mark_as_best!

      expect(first_answer).to be_best
    end

    it 'sets only one answer to be the best' do
      first_answer.mark_as_best!
      second_answer.mark_as_best!

      total_best_question_answers = question.answers.where(best: true).count

      expect(total_best_question_answers).to eq(1)
    end

    it 'sets the reward to the author of the best answer' do
      first_answer.mark_as_best!

      expect(user.reload.rewards.count).to eq(1)
    end
  end

  describe '#send_notification' do
    let(:build_answer) { build(:answer) }

    it 'enqueues NewAnswerNotificationJob' do
      expect { build_answer.save! }
        .to have_enqueued_job(NewAnswerNotificationJob)
              .on_queue('default')
    end
  end
end
