# frozen_string_literal: true

class Comment < ApplicationRecord
  include Indices::CommentsIndex

  belongs_to :user, touch: true
  belongs_to :commentable, touch: true, polymorphic: true

  validates :body, presence: true
end
