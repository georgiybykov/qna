# frozen_string_literal: true

module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :links, as: :linkable, dependent: :destroy

    accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank
  end
end
