# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question

  def index; end

  def show
    @answer = Answer.new(question: question)
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
    if current_user.author?(question)
      flash[:notice] = 'Your question has been successfully deleted!' if question.destroy
    else
      flash.now[:alert] = 'You are not able to delete this question!'
    end

    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
