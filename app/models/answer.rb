# frozen_string_literal: true

class Answer < ApplicationRecord
  include Searchable

  include Linkable
  include Votable
  include Commentable

  default_scope { order(best: :desc, created_at: :asc) }

  belongs_to :user, touch: true
  belongs_to :question, touch: true

  has_many_attached :files

  validates :body, presence: true

  after_create :send_notification

  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :id, type: :long
      indexes :body, type: :text
      indexes :user, type: :nested, properties: {
        id: { type: :long },
        email: { type: :text }
      }
    end
  end

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
