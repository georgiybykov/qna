class ReputationJob < ApplicationJob
  # rescue_from ActiveJob::DeserializationError do |exception|
  #   # handle a deleted record
  # end

  queue_as :default

  def perform(object)
    Reputation.calculate(object)
  end
end
