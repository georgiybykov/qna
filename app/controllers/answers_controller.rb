# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show

  expose :question
  expose(:answers) { question.answers }
  expose :answer

  def show; end

  def edit; end

  def create
    @answer = answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your answer has been successfully created!'
    else
      redirect_to question_path(@answer.question), alert: 'Your answer has not been created!'
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
    params
      .require(:answer)
      .permit(:body)
      .merge(user: current_user)
  end
end
