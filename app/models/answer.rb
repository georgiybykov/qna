# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :user, touch: true
  belongs_to :question, touch: true

  validates :body, presence: true

  def mark_as_best!
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)

      update!(best: true)
    end
  end
end
