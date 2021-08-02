# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module Responder
        extend ActiveSupport::Concern

        def respond(result, object, scopes, status: :ok)
          if result
            render_json object, scopes, status: status
          else
            render json: { errors: object.errors }, status: :unprocessable_entity
          end
        end

        def render_json(object, scopes, status: :ok)
          render json: object,
                 serializer: "Api::V1::#{object.class}Serializer".constantize,
                 include: scopes,
                 status: status
        end

        def render_json_list(objects, serializer_name, scopes, status: :ok)
          render json: objects,
                 each_serializer: "Api::V1::#{serializer_name}Serializer".constantize,
                 include: scopes,
                 status: status
        end
      end
    end
  end
end
