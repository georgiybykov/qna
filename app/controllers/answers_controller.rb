# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question, -> { Question.find(params[:question_id]) }
  expose :answers, -> { question.answers }
  expose :answer

  def show; end

  def new; end

  def edit; end

  def create
    @answer = answers.new(answer_params)

    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer_path(answer)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy

    redirect_to question_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
