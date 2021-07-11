# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :attachment, -> { ActiveStorage::Attachment.find_by(record_id: params[:id]) }

  authorize_resource class: ActiveStorage::Attachment

  def destroy
    authorize! :destroy, attachment

    attachment.purge
  end
end
