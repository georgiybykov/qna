# frozen_string_literal: true

describe DailyDigest, type: :service do
  subject(:daily_digest_service) { described_class.new }

  let(:users) { create_list(:user, 3) }

  it 'sends daily digests to all users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original.once
    end

    daily_digest_service.send_digest
  end
end
