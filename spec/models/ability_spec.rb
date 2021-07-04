# frozen_string_literal: true

describe Ability, type: :model, aggregate_failures: true do
  subject(:ability) { described_class.new(user) }

  describe 'when actions are performed by a guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.to be_able_to :create, Authorization }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'when actions are performed by the admin' do
    let(:user) { create(:user, :admin) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'when actions are performed by the user' do
    let(:user) { create(:user) }
    let(:not_current_user) { create(:user) }

    let(:user_question) { create(:question, user: user) }
    let(:not_current_user_question) { create(:question, user: not_current_user) }

    let(:user_answer) { create(:answer, question: user_question, user: user) }
    let(:not_current_user_answer) do
      create(:answer, question: not_current_user_question, user: not_current_user)
    end

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }

    context 'with questions' do
      it { is_expected.to be_able_to :create, Question }

      it { is_expected.to be_able_to :update, user_question }
      it { is_expected.not_to be_able_to :update, not_current_user_question }

      it { is_expected.to be_able_to :destroy, user_question }
      it { is_expected.not_to be_able_to :destroy, not_current_user_question }

      it { is_expected.to be_able_to %i[vote_up vote_down revoke_vote], not_current_user_question }
      it { is_expected.not_to be_able_to %i[vote_up vote_down revoke_vote], user_question }
    end

    context 'with answers' do
      it { is_expected.to be_able_to :create, Answer }

      it { is_expected.to be_able_to :update, user_answer }
      it { is_expected.not_to be_able_to :update, not_current_user_answer }

      it { is_expected.to be_able_to :destroy, user_answer }
      it { is_expected.not_to be_able_to :destroy, not_current_user_answer }

      it { is_expected.to be_able_to %i[vote_up vote_down revoke_vote], not_current_user_answer }
      it { is_expected.not_to be_able_to %i[vote_up vote_down revoke_vote], user_answer }

      it { is_expected.to be_able_to :set_best, user_answer }
      it { is_expected.not_to be_able_to :set_best, not_current_user_answer }
    end

    context 'with comments' do
      it { is_expected.to be_able_to :create, Comment }
    end

    context 'with attachments' do
      context 'when files belong to questions' do
        let(:question_with_file) { create(:question, :with_file, user: user) }
        let(:other_user_question_with_file) { create(:question, :with_file, user: not_current_user) }

        it { is_expected.to be_able_to :destroy, question_with_file }
        it { is_expected.not_to be_able_to :destroy, other_user_question_with_file }
      end

      context 'when files belong to answers' do
        let(:answer_with_file) { create(:answer, :with_file, user: user) }
        let(:other_user_answer_with_file) { create(:answer, :with_file, user: not_current_user) }

        it { is_expected.to be_able_to :destroy, answer_with_file }
        it { is_expected.not_to be_able_to :destroy, other_user_answer_with_file }
      end
    end

    context 'with links' do
      context 'when them belong to questions' do
        it { is_expected.to be_able_to :destroy, create(:link, linkable: user_question) }
        it { is_expected.not_to be_able_to :destroy, create(:link, linkable: not_current_user_question) }
      end

      context 'when them belong to answers' do
        it { is_expected.to be_able_to :destroy, create(:link, linkable: user_answer) }
        it { is_expected.not_to be_able_to :destroy, create(:link, linkable: not_current_user_answer) }
      end
    end
  end
end
