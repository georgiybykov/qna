# frozen_string_literal: true

module ApiHelpers
  def response_json
    @response_json ||= JSON.parse(response.body, symbolize_names: true)
  end

  def perform_request(method, path, options = {})
    send method, path, options
  end
end
