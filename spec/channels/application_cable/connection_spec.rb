# frozen_string_literal: true

describe ApplicationCable::Connection, type: :channel, aggregate_failures: true do
  let(:user) { create(:user) }
  let(:env) { instance_double('env') }

  context 'when the user is an authenticated' do
    let(:warden) { instance_double(Warden::Proxy, user: user) }

    before do
      allow_any_instance_of(described_class).to receive(:env).and_return(env) # rubocop:disable RSpec/AnyInstance

      allow(env).to receive(:[]).with('warden').and_return(warden)
    end

    it 'successfully connects' do
      connect '/cable'

      expect(connect.current_user).to eq(user)

      expect(env).to have_received(:[]).with('warden').twice
    end
  end

  context 'when the user is unauthenticated' do
    let(:warden) { instance_double('warden', user: nil) }

    before do
      allow_any_instance_of(described_class).to receive(:env).and_return(env) # rubocop:disable RSpec/AnyInstance

      allow(env).to receive(:[]).with('warden').and_return(warden)
    end

    it 'successfully connects' do
      connect '/cable'

      expect(connect.current_user).to be_nil

      expect(env).to have_received(:[]).with('warden').twice
    end
  end
end
