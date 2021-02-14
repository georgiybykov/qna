# frozen_string_literal: true

class Question < ApplicationRecord
  validates :body, presence: true
end
