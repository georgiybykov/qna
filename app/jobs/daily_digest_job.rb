# frozen_string_literal: true

class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    SendDailyDigestService.new.call!
  end
end
