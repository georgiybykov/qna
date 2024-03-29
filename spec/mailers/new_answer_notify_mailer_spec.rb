# frozen_string_literal: true

describe NewAnswerNotifyMailer, type: :mailer, aggregate_failures: true do
  describe 'notify' do
    let(:mail) { described_class.notify(answer, subscriber) }

    let(:answer) { create(:answer) }
    let(:subscriber) { create(:user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notify')
      expect(mail.to).to eq([subscriber.email])
      expect(mail.from).to eq([Rails.application.credentials.admin_email || 'no-reply@qna.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('created a new answer for the question')
    end
  end
end
