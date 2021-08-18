# frozen_string_literal: true

describe SendDailyDigest, type: :service do
  subject(:call!) { described_class.new.call! }

  context 'when there are not any questions created during last day' do
    it 'does not send daily digests' do
      expect(call!).to eq(:new_questions_not_found)
    end
  end

  context 'when there are questions created during last day' do
    let(:users) { create_list(:user, 3) }

    before { create(:question, user: users.first) }

    it 'sends daily digests to all users' do
      users.each do |user|
        expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original.once
      end

      call!
    end
  end
end
