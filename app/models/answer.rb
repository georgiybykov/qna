# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question, touch: true

  validates :body, presence: true
end
