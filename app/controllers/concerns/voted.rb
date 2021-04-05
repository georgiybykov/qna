# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down revoke_vote]
  end

  def vote_up
    # Module `include` should be before callbacks in the controller by Rails style guide.
    # So, we should not use this repeatable check as callback method.
    return render_errors if current_user.author?(@votable)

    @votable.vote_up!(current_user)

    render_json
  end

  def vote_down
    return render_errors if current_user.author?(@votable)

    @votable.vote_down!(current_user)

    render_json
  end

  def revoke_vote
    return render_errors if current_user.author?(@votable)

    @votable.revoke_vote!(current_user)

    render_json
  end

  private

  def render_json
    render json: {
      id: @votable.id,
      name: @votable.class.name.downcase,
      rating: @votable.rating
    }
  end

  def render_errors
    render json: { message: 'You do not have permissions to vote!' },
           status: :forbidden
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
