# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user, touch: true
  has_many :answers, dependent: :destroy

  has_one_attached :file

  validates :title, :body, presence: true
end
