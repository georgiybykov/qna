# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :user, touch: true
  belongs_to :question, touch: true
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def mark_as_best!
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)

      update!(best: true)
    end
  end
end
