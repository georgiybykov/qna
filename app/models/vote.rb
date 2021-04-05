# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user, touch: true
  belongs_to :votable, touch: true, polymorphic: true

  validates :user, uniqueness: { scope: %i[votable_id votable_type] }
  validates :value, presence: true, inclusion: { in: [-1, 1] }
end
