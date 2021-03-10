# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_permissions(answer) }, only: %i[update destroy]

  expose :question
  expose(:answers) { question.answers }
  expose :answer

  def create
    @answer = answers.new(answer_params.merge(user: current_user))
    @answer.save
  end

  def update
    answer.update(answer_params.merge(user: current_user))
    @question = answer.question
  end

  delegate :destroy, to: :answer

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
