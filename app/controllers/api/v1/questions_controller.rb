# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      expose :questions, -> { Question.includes(:user) }
      expose :question, -> { Question.with_attached_files.find(params[:id]) }

      after_action :publish_question, only: :create

      authorize_resource class: Question

      def index
        render_json_list questions, Question, :author
      end

      def show
        render_json question, %i[comments files links author]
      end

      def create
        @question = Question.new(question_params.merge(user_id: current_resource_owner.id))

        respond @question.save, @question, :author, status: :created
      end

      def update
        authorize! :update, question

        result = question.update(question_params.merge(user_id: current_resource_owner.id))

        respond result, question, %i[comments files links author]
      end

      def destroy
        authorize! :destroy, question

        render json: {}, status: :ok if question.destroy!
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end

      def publish_question
        return if @question.errors.any?

        ActionCable.server.broadcast(
          'questions_list',
          controller_renderer.render(
            partial: 'questions/question',
            locals: {
              question: @question,
              current_user: current_resource_owner
            }
          )
        )
      end
    end
  end
end
