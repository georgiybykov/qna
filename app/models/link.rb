# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, touch: true, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https ftp]),
                            message: 'is not a valid URL' }
end
