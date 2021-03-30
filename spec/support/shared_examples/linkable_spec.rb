# frozen_string_literal: true

shared_examples 'linkable' do
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:links) }
end
