require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  setup do
    @report_1 = reports(:one)
    @report_2 = reports(:two)
    @report_3 = reports(:three)
    @user     = users(:one)
    sign_in @user, scope: :user
  end

  test '#index should be filtered, paginated and ordered' do
    get :index
    assert_response :success
    assert_select '#total-income', '$200.00'
    assert_select '#reports .report', count: 2
    assert_select "#reports #report-#{@report_1.id} .income", text: '$95.00'
    assert_select "#reports #report-#{@report_2.id} .income", text: '$105.00'

    get :index, params: { per_page: 1, page: 1 }
    assert_response :success
    assert_select '#total-income', '$200.00'
    assert_select '#reports .report', count: 1
    assert_select "#reports #report-#{@report_2.id} .income", text: '$105.00'
  end

  test '#new' do
    get :new
    assert_response :success
    assert_select '#report_file', count: 1
  end

  test '#create' do
    assert_difference('@user.reports.count') do
      assert_difference('@user.reload.income', 95) do
        post :create, params: { report: { name: @report_1.name, file: fixture_file_upload(file_fixture('example_input.tab')) } }
      end
    end

    assert_redirected_to report_url(Report.last)
  end

  test '#show only reports from user' do
    get :show, params: { id: @report_1 }
    assert_response :success
    assert_select '#report_file', count: 0
    assert_select '.income', '$95.00'

    assert_raises(ActiveRecord::RecordNotFound) {
      get :show, params: { id: @report_3 }
    }
  end

  test '#edit only reports from user' do
    get :edit, params: { id: @report_1 }
    assert_response :success
    assert_select '#report_file', count: 1

    assert_raises(ActiveRecord::RecordNotFound) {
      get :edit, params: { id: @report_3 }
    }
  end

  test '#update only reports from user' do
    patch :update, params: { id: @report_1, report: { name: 'name' } }
    assert_redirected_to report_url(@report_1)

    assert_raises(ActiveRecord::RecordNotFound) {
      patch :update, params: { id: @report_3, report: { name: 'name' } }
    }
  end

  test '#destroy only reports from user' do
    assert_difference('@user.reports.count', -1) do
      delete :destroy, params: { id: @report_1 }
    end

    assert_redirected_to reports_url

    assert_raises(ActiveRecord::RecordNotFound) {
      delete :destroy, params: { id: @report_3 }
    }
  end
end
