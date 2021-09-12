# frozen_string_literal: true

class Question < ApplicationRecord
  include Searchable

  include Linkable
  include Votable
  include Commentable

  belongs_to :user, touch: true

  has_one :reward, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
  validates :title, uniqueness: true

  after_create :subscribe_author!

  scope :created_after, ->(date) { where('created_at > ?', date) }

  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :id, type: :long
      indexes :title, type: :text
      indexes :body, type: :text
      indexes :user, type: :nested, properties: {
        id: { type: :long },
        email: { type: :text }
      }
    end
  end

  private

  def subscribe_author!
    subscriptions.create!(user: user)
  end
end
