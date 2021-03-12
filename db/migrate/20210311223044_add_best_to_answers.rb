# frozen_string_literal: true

class AddBestToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :best, :boolean, default: false, null: false
  end
end
