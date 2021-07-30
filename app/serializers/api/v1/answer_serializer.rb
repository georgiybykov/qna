# frozen_string_literal: true

module Api
  module V1
    class AnswerSerializer < ActiveModel::Serializer
      attributes :id, :body, :best, :question_id, :user_id, :created_at, :updated_at
    end
  end
end
