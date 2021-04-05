# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy]
  before_action -> { check_permissions(@question) }, only: %i[update destroy]

  expose :questions, -> { Question.all }

  def index; end

  def show
    @answer = @question.answers.new
    @answer.links.build
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
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

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[id name url _destroy],
                                     reward_attributes: %i[title image])
  end
end
