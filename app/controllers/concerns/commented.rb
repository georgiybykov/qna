# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @commentable.comments.new(comment_params.merge(user: current_user))
    @comment.save

    render 'comments/create'
  end

  private

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments_for_page_with_question_#{question_id}",
      comment: @comment
    )
  end

  def question_id
    return @question.id if controller_name.to_sym.eql?(:questions)

    @commentable.question.id
  end
end
