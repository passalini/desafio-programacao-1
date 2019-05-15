class ProcessReportJob < ApplicationJob
  queue_as :default

  def perform(report)
    report.finish_porcessing!
    send_notifications_from(report)
  end

  private

  def view_helper
    @view_helper ||= Class.new do
      include ActionView::Helpers
      include ApplicationHelper
    end.new
  end

  def send_notifications_from(report)
    send_message total_income: report.user.income
    send_message report_id: report.id,
      income: view_helper.number_to_currency(report.income),
      status: view_helper.html_report_state(report)
  end

  def send_message(message)
    ActionCable.server.broadcast 'report_notifications_channel', message
  end
end
