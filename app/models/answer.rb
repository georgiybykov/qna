# frozen_string_literal: true

class Answer < ApplicationRecord
  include Indices::AnswersIndex

  include Linkable
  include Votable
  include Commentable

  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :user, touch: true
  belongs_to :question, touch: true

  has_many_attached :files

  validates :body, presence: true

  after_create :send_notification

  def mark_as_best!
    transaction do
      self.class.where(question_id: question_id).update_all(best: false)

      update!(best: true)

      question.reward&.update!(user: user)
    end
  end

  private

  def send_notification
    NewAnswerNotificationJob.perform_later(self)
  end
end
