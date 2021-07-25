# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource class: User

      def index
        @questions = Question.all
        render json: @questions.to_json(include: :answers)
      end
    end
  end
end