require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @report = reports(:one)
    sign_in users(:one), scope: :user
  end

  test "should get index" do
    get reports_url
    assert_response :success
    assert_select '#reports .report', count: 1
    assert_select "#reports #report-#{@report.id} .income", text: '$95.00'
  end

  test "should get new" do
    get new_report_url
    assert_response :success
    assert_select '#report_file', count: 1
  end

  test "should create report" do
    assert_difference('Report.count') do
      post reports_url, params: { report: { name: @report.name, file: fixture_file_upload(file_fixture('example_input.tab')) } }
    end

    assert_redirected_to report_url(Report.last)
  end

  test "should show report" do
    get report_url(@report)
    assert_response :success
    assert_select '#report_file', count: 0
    assert_select '.income', '$95.00'
  end

  test "should get edit" do
    get edit_report_url(@report)
    assert_response :success
    assert_select '#report_file', count: 1
  end

  test "should update report" do
    patch report_url(@report), params: { report: { name: 'name' } }
    assert_redirected_to report_url(@report)
  end

  test "should destroy report" do
    assert_difference('Report.count', -1) do
      delete report_url(@report)
    end

    assert_redirected_to reports_url
  end
end
