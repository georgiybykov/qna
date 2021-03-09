# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

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

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
