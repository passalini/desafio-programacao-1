class ProcessReportJob < ApplicationJob
  queue_as :default

  def perform(report)
    report.process!
    send_notifications_from(report)
  end

  private

  def send_notifications_from(report)
    send_message total_income: ViewHelper.number_to_currency(report.user.income)
    send_message report_id: report.id,
      income: ViewHelper.number_to_currency(report.income),
      status: ViewHelper.html_report_state(report)
  end

  def send_message(message)
    ActionCable.server.broadcast 'report_notifications_channel', message
  end
end
