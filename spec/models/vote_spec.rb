# frozen_string_literal: true

describe Vote, type: :model, aggregate_failures: true do
  it { is_expected.to belong_to(:user).touch(true) }
  it { is_expected.to belong_to(:votable).touch(true) }

  it { is_expected.to validate_presence_of :value }

  it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }

  it { is_expected.to have_db_column(:value).of_type(:integer) }

  describe 'the uniqueness of the user scoped to votable' do
    before do
      user = create(:user)
      votable_question = create(:question, id: 1, user: user)
      votable_answer = create(:answer, id: 1, user: user)

      create(:vote, user: user, votable: votable_question, value: 1)
      create(:vote, user: user, votable: votable_answer, value: 1)
    end

    it { is_expected.to validate_uniqueness_of(:user).scoped_to(%i[votable_id votable_type]) }
  end
end
