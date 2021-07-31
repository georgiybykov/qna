# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      authorize_resource

      expose :question, id: -> { params[:question_id] }
      expose :answer, -> { Answer.with_attached_files.find(params[:id]) }

      def index
        render json: question.answers,
               each_serializer: Api::V1::AnswerSerializer,
               include: :author
      end

      def show
        render json: answer,
               serializer: Api::V1::AnswerSerializer,
               include: %i[comments files links author]
      end
    end
  end
end
