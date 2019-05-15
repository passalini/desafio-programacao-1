class ViewHelper
  extend ActionView::Helpers
  extend ApplicationHelper

  def self.render(object)
    ApplicationController.render(object)
  end
end
