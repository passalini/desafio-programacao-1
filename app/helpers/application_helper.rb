module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-danger"
    when :alert then "alert alert-warning"
    end
  end

  def html_report_state(report)
    icon =
      case report.aasm_state
      when 'enqueued' then 'clock-o'
      when 'done' then 'check-circle'
      end


    tag.i class: "fa fa-#{icon} fa-fw", data: { toggle: 'tooltip' },
      title: report.aasm_state.humanize
  end

  def html_report_income(report)
    return '-' unless report.done?
    number_to_currency(report.income)
  end

  def shoud_show_back?
    ![root_path, reports_path].include?(request.path) && !devise_controller?
  end
end
