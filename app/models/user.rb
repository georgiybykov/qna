# frozen_string_literal: true

class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  def author?(object)
    object.user_id.eql?(id)
  end
end
