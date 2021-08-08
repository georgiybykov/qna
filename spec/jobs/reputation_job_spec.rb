# frozen_string_literal: true

describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls Reputation#calculate' do
    expect(Reputation).to receive(:calculate).with(question)
    described_class.perform_now(question)
  end
end
