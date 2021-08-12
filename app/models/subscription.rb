# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user, :question, presence: true
  validates :user, uniqueness: { scope: :question_id }
end
