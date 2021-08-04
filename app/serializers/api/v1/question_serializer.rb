# frozen_string_literal: true

module Api
  module V1
    class QuestionSerializer < ActiveModel::Serializer
      attributes :id, :title, :body, :created_at, :updated_at, :short_title

      has_many :answers, each_serializer: Api::V1::AnswerSerializer
      has_many :comments, each_serializer: Api::V1::CommentSerializer
      has_many :files, serializer: Api::V1::FileSerializer
      has_many :links, each_serializer: Api::V1::LinkSerializer
      belongs_to :user, key: :author

      def short_title
        object.title.truncate(7)
      end
    end
  end
end
