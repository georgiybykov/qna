# frozen_string_literal: true

require 'rails_helper'

describe Answer, type: :model do
  it { should belong_to(:question).touch(true) }

  it { should validate_presence_of :body }
end
