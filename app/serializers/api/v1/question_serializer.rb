# frozen_string_literal: true

module Api
  module V1
    class QuestionSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :id, :title, :body, :created_at, :updated_at, :short_title

      has_many :comments, each_serializer: Api::V1::CommentSerializer
      has_many :files
      has_many :links, each_serializer: Api::V1::LinkSerializer
      belongs_to :user, key: :author

      def short_title
        object.title.truncate(7)
      end

      def files
        object.files.map { |file| rails_blob_path(file, only_path: true) }
      end
    end
  end
end
