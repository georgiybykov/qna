# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link

  def destroy
    authorize! :destroy, link.linkable

    link.destroy
  end
end
