# frozen_string_literal: true

class Comment < ApplicationRecord
  include Searchable

  belongs_to :user, touch: true
  belongs_to :commentable, touch: true, polymorphic: true

  validates :body, presence: true

  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :body, type: :text
      indexes :user, type: :nested, properties: {
        id: { type: :long },
        email: { type: :text }
      }
    end
  end
end
