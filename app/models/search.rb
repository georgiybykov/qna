# frozen_string_literal: true

class Search
  include ActiveModel::Model

  attr_accessor :query, :scope

  validates :query, :scope, presence: true
  validates :query, length: { minimum: 3 }
end
