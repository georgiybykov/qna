# frozen_string_literal: true

class SearchesController < ApplicationController
  skip_authorization_check

  def index
    case QuerySearchService.new.call(search: Search.new(search_params))
    in Array => result
      @search_results = result
    in String => error_message
      redirect_to root_path, alert: error_message
    end
  end

  private

  def search_params
    params
      .require(:search)
      .permit(:query, :scope)
  end
end
