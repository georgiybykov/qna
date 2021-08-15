# frozen_string_literal: true

describe NewAnswerNotificationJob, type: :job do
  let(:send_new_answer_notification_service) do
    instance_double(SendNewAnswerNotification)
  end

  let(:answer) { create(:answer) }

  before do
    allow(SendNewAnswerNotification)
      .to receive(:new)
            .and_return(send_new_answer_notification_service)
  end

  it 'calls SendNewAnswerNotification#call' do
    expect(send_new_answer_notification_service)
      .to receive(:call)
            .with(answer: answer)
            .once

    described_class.perform_now(answer)
  end
end
