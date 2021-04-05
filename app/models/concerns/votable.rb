# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up!(user)
    return if previous_vote_of(user)

    votes.create!(user: user, value: 1)
  end

  def vote_down!(user)
    return if previous_vote_of(user)

    votes.create!(user: user, value: -1)
  end

  def revoke_vote_of(user)
    previous_vote_of(user)&.destroy!
  end

  def rating
    votes.sum(:value)
  end

  private

  def previous_vote_of(user)
    votes.find_by(user: user)
  end
end
