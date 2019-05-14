module Pagination
  extend ActiveSupport::Concern

  private

  def paginate(resources)
    resources = resources.
      page(pagination_params[:page]).
      per(pagination_params[:per_page])

    @more_link = build_pagination_link(resources)

    resources
  end

  def pagination_params
    params.permit(:page, :per_page)
  end

  def build_pagination_link(resources)
    total_pages = resources.total_pages
    current_page = resources.current_page
    return if current_page == total_pages

    pagination_param = { page: current_page + 1, per_page: pagination_params[:per_page] }.to_param
    request.path + '?' + pagination_param
  end
end
