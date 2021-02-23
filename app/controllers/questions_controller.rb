# frozen_string_literal: true

class QuestionsController < ApplicationController
  expose :questions, -> { Question.all }
  expose :question

  def show; end

  def new; end

  def edit; end

  def create
    if question.save
      redirect_to question_path(question)
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    question.destroy

    redirect_to question_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
