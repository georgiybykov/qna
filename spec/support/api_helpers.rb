# frozen_string_literal: true

module ApiHelpers
  def response_json
    @response_json ||= JSON.parse(response.body, symbolize_names: true)
  end
end
