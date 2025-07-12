# frozen_string_literal: true

module Searchable

  extend ActiveSupport::Concern

  included do
    helper_method :search_params
  end

  private

  def setup_search(model, default_sort: 'id desc', includes: [])
    @search = model.ransack(search_params)
    @search.sorts = default_sort if @search.sorts.empty?

    result = @search.result
    result = result.includes(includes) if includes.any?
    result
  end

  def search_params
    params[:q]
  end

end
