# frozen_string_literal: true

describe DailyDigestMailer, type: :mailer, aggregate_failures: true do
  describe '#digest' do
    let(:user) { create(:user) }
    let(:mail) { described_class.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@qna.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Take a look at new questions:')
    end
  end
end
