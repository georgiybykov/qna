# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource

      expose :questions, -> { Question.includes(:user) }
      expose :question, -> { Question.with_attached_files.find(params[:id]) }

      def index
        render json: questions,
               each_serializer: Api::V1::QuestionSerializer,
               include: [:author]
      end

      def show
        render json: question,
               serializer: Api::V1::QuestionSerializer,
               include: %i[comments files links author]
      end
    end
  end
end
