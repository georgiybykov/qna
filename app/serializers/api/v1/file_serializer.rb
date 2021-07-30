# frozen_string_literal: true

module Api
  module V1
    class FileSerializer < ActiveModel::Serializer
      include Rails.application.routes.url_helpers

      attributes :url

      def url
        rails_blob_path(object, only_path: true)
      end
    end
  end
end
