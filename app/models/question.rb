# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable

  belongs_to :user, touch: true

  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
