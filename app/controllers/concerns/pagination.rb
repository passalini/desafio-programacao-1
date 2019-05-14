module Pagination
  extend ActiveSupport::Concern

  private

  def paginate(resources)
    resources.
      page(pagination_params[:page]).
      per(pagination_params[:per_page])
  end

  def pagination_params
    params.permit(:page, :per_page)
  end
end
