# frozen_string_literal: true

module Indices
  module UsersIndex
    extend ActiveSupport::Concern

    included do
      include Searchable

      settings index: { number_of_shards: 1 } do
        mappings dynamic: false do
          indexes :email, type: :text
        end
      end
    end
  end
end
