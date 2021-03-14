# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]
  before_action -> { check_permissions(@question) }, only: %i[update destroy]

  expose :questions, -> { Question.all }

  def index; end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))

    if @question.save
      redirect_to question_path(@question), notice: 'Your question has been successfully created!'
    else
      render :new
    end
  end

  def update
    @question.update(question_params.merge(user: current_user))
  end

  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_path }
      format.js { render :destroy }
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
