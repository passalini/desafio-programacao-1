App.report_notifications = App.cable.subscriptions.create "ReportNotificationsChannel",
  connected: ->
    console.log('connected to report channel')

  disconnected: ->
    console.log('disconnected to report channel')

  received: (data) ->
    update_report(data)
    insert_report(data)

update_report = (data) ->
  $('#total-income').html(data.total_income)

  if data.report_id
    report = "#report-#{data.report_id}"
    $("#{report} .income").html(data.income)
    $("#{report} .status").html(data.status)

insert_report = (data) ->
  if data.report
    $('#reports.js-reports').prepend(data.report);
