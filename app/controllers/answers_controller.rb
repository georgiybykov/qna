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
    if current_user.author?(answer)
      flash[:notice] = 'Your answer has been successfully deleted!' if answer.destroy
    else
      flash.now[:alert] = 'You are not able to delete this answer!'
    end

    redirect_to answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
