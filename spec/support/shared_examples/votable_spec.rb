# frozen_string_literal: true

shared_examples 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  let(:votable) { create(described_class.to_s.underscore.to_sym) }

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe '#vote_up!' do
    before { votable.vote_up!(user) }

    context 'when the user votes up first time' do
      specify do
        last_user_vote_value = user.reload.votes.last.value

        expect(last_user_vote_value).to eq(1)
      end
    end

    context 'when the user votes up twice' do
      before { votable.vote_up!(user) }

      it { expect(votable.rating).to eq(1) }
    end
  end

  describe '#vote_down!' do
    before { votable.vote_down!(user) }

    context 'when the user votes down first time' do
      specify do
        last_user_vote_value = user.reload.votes.last.value

        expect(last_user_vote_value).to eq(-1)
      end
    end

    context 'when the user votes down twice' do
      before { votable.vote_down!(user) }

      it { expect(votable.rating).to eq(-1) }
    end
  end

  describe '#revoke_vote_of' do
    context 'when the user revokes its up vote' do
      before do
        votable.vote_up!(user)

        votable.revoke_vote_of(user)
      end

      specify do
        expect(user.reload.votes.count).to eq(0)
      end
    end

    context 'when the user revokes its down vote' do
      before do
        votable.vote_down!(user)

        votable.revoke_vote_of(user)
      end

      specify do
        expect(user.reload.votes.count).to eq(0)
      end
    end

    context 'when the user has not been voted and tries to revoke the vote' do
      before { votable.revoke_vote_of(user) }

      specify do
        expect(user.reload.votes.count).to eq(0)
      end
    end
  end

  describe '#rating' do
    before do
      votable.vote_up!(user)
      votable.vote_up!(another_user)
    end

    it { expect(votable.rating).to eq(2) }
  end
end
