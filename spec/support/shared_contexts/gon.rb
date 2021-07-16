# frozen_string_literal: true

shared_context 'with gon stores shared params' do
  let(:gon) { RequestStore.store[:gon].gon }
  before { Gon.clear }
end
