# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      expose :questions, -> { Question.includes(:user) }
      expose :question, -> { Question.with_attached_files.find(params[:id]) }

      authorize_resource class: Question

      def index
        render json: questions,
               each_serializer: Api::V1::QuestionSerializer,
               include: :author
      end

      def show
        render_question(question)
      end

      def create
        question = Question.new(question_params.merge(user_id: current_resource_owner.id))

        if question.save
          render_question(question, status: :created)
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, question

        if question.update(question_params.merge(user_id: current_resource_owner.id))
          render_question(question)
        else
          render json: { errors: question.errors }, status: :unprocessable_entity
        end
      end

      private

      def render_question(question, status: :ok)
        render json: question,
               serializer: Api::V1::QuestionSerializer,
               include: %i[comments files links author],
               status: status
      end

      def question_params
        params.require(:question).permit(:title, :body)
      end
    end
  end
end
