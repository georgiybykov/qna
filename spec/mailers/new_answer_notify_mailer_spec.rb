# frozen_string_literal: true

describe NewAnswerNotifyMailer, type: :mailer, aggregate_failures: true do
  describe 'notify' do
    let(:answer) { create(:answer) }
    let(:mail) { described_class.notify(answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notify')
      expect(mail.to).to eq([answer.question.user.email])
      expect(mail.from).to eq(['admin@qna.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('created a new answer for the question')
    end
  end
end
