# frozen_string_literal: true

module Indices
  module AnswersIndex
    extend ActiveSupport::Concern

    included do
      include Searchable

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
    end
  end
end
