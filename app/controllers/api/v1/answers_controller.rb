# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      authorize_resource

      expose :question, id: -> { params[:question_id] }

      def index
        render json: question.answers,
               each_serializer: Api::V1::AnswerSerializer
      end
    end
  end
end
