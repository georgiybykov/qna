# frozen_string_literal: true

module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email, :admin, :created_at, :updated_at
    end
  end
end
