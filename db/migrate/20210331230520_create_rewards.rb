# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :title, present: true, null: false, limit: 50
      t.references :question, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
