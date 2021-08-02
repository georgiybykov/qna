# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      expose :question, id: -> { params[:question_id] }
      expose :answer, -> { Answer.with_attached_files.find(params[:id]) }

      authorize_resource class: Answer

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

      def create
        answer = question.answers.new(answer_params.merge(user_id: current_resource_owner.id))

        if answer.save
          render_answer(answer, status: :created)
        else
          render json: { errors: answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, answer

        if answer.update(answer_params.merge(user_id: current_resource_owner.id))
          render_answer(answer)
        else
          render json: { errors: answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, answer

        render json: {}, status: :ok if answer.destroy!
      end

      private

      def render_answer(answer, status: :ok)
        render json: answer,
               serializer: Api::V1::AnswerSerializer,
               include: %i[comments files links author],
               status: status
      end

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
