# frozen_string_literal: true

describe DailyDigestJob, type: :job do
  let(:daily_digest_service) { instance_double(DailyDigest) }

  before { allow(DailyDigest).to receive(:new).and_return(daily_digest_service) }

  it 'calls DailyDigest#send_digest' do
    expect(daily_digest_service).to receive(:send_digest).once

    described_class.perform_now
  end
end
