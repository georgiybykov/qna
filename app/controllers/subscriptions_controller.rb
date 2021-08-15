# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  expose :question, id: -> { params[:question_id] }
  expose :subscription

  authorize_resource class: Subscription

  def create
    @subscription = question.subscriptions.create(user_id: current_user.id)
  end

  def destroy
    authorize! :destroy, subscription

    subscription.destroy
  end
end
