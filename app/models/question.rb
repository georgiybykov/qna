class Question < ApplicationRecord
  validates :body, presence: true
end
