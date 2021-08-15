# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[update destroy set_best]

  expose :question, id: -> { params[:question_id] }
  expose :answer_question, -> { @answer.question }

  after_action :publish_answer, only: :create

  include Voted
  include Commented

  authorize_resource except: :comment
  skip_authorization_check only: :comment

  def create
    @answer = question.answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    @answer.update(answer_params.merge(user: current_user))
  end

  def destroy
    @answer.destroy
  end

  def set_best
    @answer.mark_as_best!
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   files: [],
                                   links_attributes: %i[id name url _destroy])
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
