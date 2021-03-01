# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user, optional: true
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
