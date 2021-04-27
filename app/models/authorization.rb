# frozen_string_literal: true

class Authorization < ApplicationRecord
  belongs_to :user, touch: true

  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
end
