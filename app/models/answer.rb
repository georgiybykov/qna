# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Votable

  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :user, touch: true
  belongs_to :question, touch: true

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best!
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)

      update!(best: true)

      question.reward&.update!(user: user)
    end
  end
end
