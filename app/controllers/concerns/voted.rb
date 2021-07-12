# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down revoke_vote]
    before_action -> { authorize_votable(@votable) }, only: %i[vote_up vote_down revoke_vote]
  end

  def vote_up
    @votable.vote_up!(current_user)

    render_json
  end

  def vote_down
    @votable.vote_down!(current_user)

    render_json
  end

  def revoke_vote
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

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def authorize_votable(resource)
    authorize! :vote_actions, resource
  end
end
