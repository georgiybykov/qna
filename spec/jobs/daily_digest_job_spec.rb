# frozen_string_literal: true

describe DailyDigestJob, type: :job do
  let(:daily_digest_service) { instance_double(SendDailyDigest) }

  before { allow(SendDailyDigest).to receive(:new).and_return(daily_digest_service) }

  it 'calls SendDailyDigest#call' do
    expect(daily_digest_service).to receive(:call).once

    described_class.perform_now
  end
end
