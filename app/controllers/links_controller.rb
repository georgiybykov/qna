# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_permissions(link.linkable) }, only: :destroy

  expose :link

  def destroy
    link.destroy
  end
end
