# frozen_string_literal: true

class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions'
  end
end
