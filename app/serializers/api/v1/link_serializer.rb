# frozen_string_literal: true

module Api
  module V1
    class LinkSerializer < ActiveModel::Serializer
      attributes :id, :name, :url, :created_at, :updated_at
    end
  end
end
