# frozen_string_literal: true

describe QuestionsChannel, type: :channel, aggregate_failures: true do
  subject(:subscribed_channel) do
    subscribe

    subscription
  end

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  context 'when there is no stub connection' do
    it { is_expected.to be_confirmed }
  end

  context 'when there is stub connection for the unauthenticated user' do
    before { stub_connection(current_user: nil) }

    it { is_expected.to be_confirmed }
  end

  context 'when there is stub connection for the authenticated user' do
    before { stub_connection(current_user: user) }

    it 'successfully subscribes' do
      expect(subscribed_channel).to be_confirmed

      expect(subscribed_channel.current_user).to eq(user)
    end
  end

  context 'when there is one active stream from the channel' do
    before do
      subscribed_channel

      perform :follow
    end

    it 'streams successfully from the channel' do
      expect(subscribed_channel).to have_stream_from('questions')

      expect(subscribed_channel.send(:streams)).to eq(['questions'])
    end
  end

  context 'when there are few active streams from the channel' do
    before do
      subscribed_channel

      3.times { perform :follow }
    end

    it 'streams successfully from the channel' do
      expect(subscribed_channel).to have_stream_from('questions')

      expect(subscribed_channel.send(:streams).count).to eq(3)
    end
  end
end
