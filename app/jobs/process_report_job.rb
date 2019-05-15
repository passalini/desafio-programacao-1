class ProcessReportJob < ApplicationJob
  queue_as :default

  def perform(report)
    report.finish_porcessing!
  end
end
