# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      expose :question, id: -> { params[:question_id] }
      expose :answer, -> { Answer.with_attached_files.find(params[:id]) }

      after_action :publish_answer, only: :create

      authorize_resource class: Answer

      def index
        render_json_list question.answers, Answer, :author
      end

      def show
        render_json answer, %i[comments files links author]
      end

      def create
        @answer = question.answers.new(answer_params.merge(user_id: current_resource_owner.id))

        respond @answer.save, @answer, :author, status: :created
      end

      def update
        authorize! :update, answer

        result = answer.update(answer_params.merge(user_id: current_resource_owner.id))

        respond result, answer, %i[comments files links author]
      end

      def destroy
        authorize! :destroy, answer

        render json: {}, status: :ok if answer.destroy!
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end

      def publish_answer
        return if @answer.errors.any?

        ActionCable.server.broadcast(
          "answers_for_page_with_question_#{question.id}",
          answer: @answer,
          rating: @answer.rating,
          links: @answer.links
        )
      end
    end
  end
end
