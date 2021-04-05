# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, %i[user_id votable_id votable_type], unique: true
  end
end
