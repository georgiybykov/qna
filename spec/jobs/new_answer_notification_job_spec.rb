# frozen_string_literal: true

describe NewAnswerNotificationJob, type: :job do
  it 'enqueues NewAnswerNotificationJob' do
    expect { described_class.perform_later }
      .to have_enqueued_job(described_class)
            .on_queue('default')
  end
end
