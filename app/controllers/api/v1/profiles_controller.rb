# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < ApplicationController
      protect_from_forgery with: :null_session

      before_action :doorkeeper_authorize!

      authorize_resource class: User

      def me
        render json: current_resource_owner
      end

      private

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def current_ability
        @current_ability ||= Ability.new(current_resource_owner)
      end
    end
  end
end
