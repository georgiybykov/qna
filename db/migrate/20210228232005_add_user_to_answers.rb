# frozen_string_literal: true

class AddUserToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :user, index: true, foreign_key: true
  end
end
