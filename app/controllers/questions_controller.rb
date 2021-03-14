# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action -> { check_permissions(question) }, only: %i[update destroy]

  expose :questions, -> { Question.all }
  expose :question

  def index; end

  def show
    @answer = question.answers.new
  end

  def new; end

  def create
    question.user = current_user

    if question.save
      redirect_to question_path(question), notice: 'Your question has been successfully created!'
    else
      render :new
    end
  end

  def update
    question.update(question_params.merge(user: current_user))
  end

  def destroy
    question.destroy

    respond_to do |format|
      format.html { redirect_to questions_path }
      format.js { render :destroy }
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :file)
  end
end
