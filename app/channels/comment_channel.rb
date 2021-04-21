# frozen_string_literal: true

class CommentChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_for_page_with_question_#{data['question_id']}"
  end
end
