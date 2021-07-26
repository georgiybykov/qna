# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource

      def index
        @questions = Question.includes(:user, :answers)
        render json: @questions, each_serializer: Api::V1::QuestionSerializer
      end
    end
  end
end
