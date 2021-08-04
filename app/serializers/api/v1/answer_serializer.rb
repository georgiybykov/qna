# frozen_string_literal: true

module Api
  module V1
    class AnswerSerializer < ActiveModel::Serializer
      attributes :id, :body, :best, :question_id, :created_at, :updated_at

      has_many :comments, each_serializer: Api::V1::CommentSerializer
      has_many :files, serializer: Api::V1::FileSerializer
      has_many :links, each_serializer: Api::V1::LinkSerializer
      belongs_to :user, key: :author
    end
  end
end
