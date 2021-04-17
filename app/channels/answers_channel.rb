# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data['question_id']}"
  end
end
