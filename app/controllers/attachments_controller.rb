# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { check_permissions(attachment.record) }, only: :destroy

  expose :attachment, -> { ActiveStorage::Attachment.find_by(record_id: params[:id]) }

  def destroy
    attachment.purge
  end
end
