# frozen_string_literal: true

describe DailyDigestJob, type: :job do
  let(:send_daily_digest_service) { instance_double(SendDailyDigest) }

  before { allow(SendDailyDigest).to receive(:new).and_return(send_daily_digest_service) }

  it 'calls SendDailyDigest#call' do
    expect(send_daily_digest_service).to receive(:call!).once

    described_class.perform_now
  end

  it 'enqueues DailyDigestJob' do
    expect { described_class.perform_later }
      .to have_enqueued_job(described_class)
            .on_queue('default')
  end
end
