# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose(:answers) { question.answers }
  expose :answer

  def edit; end

  def create
    @answer = answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question), notice: 'Your answer has been successfully created!'
    else
      render 'questions/show'
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
    if current_user.author?(answer)
      flash[:notice] = 'Your answer has been successfully deleted!' if answer.destroy
    else
      flash.now[:alert] = 'You are not able to delete this answer!'
    end

    redirect_to answer.question
  end

  private

  def answer_params
    params
      .require(:answer)
      .permit(:body)
      .merge(user: current_user)
  end
end
