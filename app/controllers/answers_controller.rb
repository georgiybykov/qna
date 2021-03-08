# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!

  expose :question
  expose(:answers) { question.answers }
  expose :answer

  def edit; end

  def create
    @answer = answers.create(answer_params.merge(user: current_user))
    @answer.save

    # render 'answers/create.js'

    # respond_to do |format|
    #   format.js
    # end

    # render 'answers/create.js'
    # render :create, handlers: :erb, format: :js
    # , :handlers => [:erb], :formats => [:js])
    # render 'questions/show'

    # if @answer.save
    #   redirect_to question_path(@answer.question), notice: 'Your answer has been successfully created!'
    # else
    #   render 'questions/show'
    # end
  end

  def update
    if answer.update(answer_params.merge(user: current_user))
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
    params.require(:answer).permit(:body)
  end
end
