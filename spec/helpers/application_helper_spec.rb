# frozen_string_literal: true

describe ApplicationHelper, type: :helper, aggregate_failures: true do
  describe '#greeting_in_header' do
    subject(:greeting) { helper.greeting_in_header(user) }

    context 'when the user is defined' do
      let(:user) { create(:user) }

      it { is_expected.to eq(user.email) }
    end

    context 'when the user is not defined' do
      let(:user) { nil }

      it { expect { greeting }.to raise_error(NoMethodError) }
    end
  end
end
