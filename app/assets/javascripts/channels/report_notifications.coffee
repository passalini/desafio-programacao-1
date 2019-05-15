App.report_notifications = App.cable.subscriptions.create "ReportNotificationsChannel",
  connected: ->
    console.log('connected to report channel')

  disconnected: ->
    console.log('disconnected to report channel')

  received: (data) ->
    update_report_index(data)

update_report_index = (data) ->
  $('#total-income').html(data.total_income)

  if data.report_id
    report = "#report-#{data.report_id}"
    $("#{report} .income").html(data.income)
    $("#{report} .status").html(data.status)
