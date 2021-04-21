# frozen_string_literal: true

class QuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from 'questions_list'
  end
end
