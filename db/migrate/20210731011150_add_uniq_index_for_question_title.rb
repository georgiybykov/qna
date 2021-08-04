# frozen_string_literal: true

class AddUniqIndexForQuestionTitle < ActiveRecord::Migration[6.1]
  def change
    add_index :questions, :title, unique: true
  end
end
