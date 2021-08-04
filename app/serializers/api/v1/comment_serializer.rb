# frozen_string_literal: true

module Api
  module V1
    class CommentSerializer < ActiveModel::Serializer
      attributes :id, :body, :user_id, :created_at, :updated_at
    end
  end
end
