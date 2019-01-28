require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'report has a file' do
    assert_have_one_attached(Report, :file)
  end

  test 'report presence validations' do
    object = Report.new
    assert_not object.valid?
    assert_includes object.errors.messages.keys, :name
    assert_includes object.errors.messages.keys, :file
  end

  test 'file structure' do
    file_1    = 'example_input.tab'
    file_2    = 'invalid_example_input.tab'
    report_1 = Report.new(name: 'test valid headers', user: @user)
    report_2 = Report.new(name: 'test invalid headers', user: @user)
    report_1.file.attach(io: file_fixture(file_1).open, filename: file_1)
    report_2.file.attach(io: file_fixture(file_2).open, filename: file_1)

    assert     report_1.valid?
    assert_not report_2.valid?
    assert_includes report_2.errors.messages[:file], "is invalid"
  end

  test '#process_file' do
    file_1    = 'example_input.tab'
    file_2    = 'example_2_input.tab'
    report_1 = Report.new(name: 'test valid headers 1', user: @user)

    report_1.file.attach(io: file_fixture(file_1).open, filename: file_1)
    assert report_1.save
    assert_equal 95.0, report_1.income

    report_1.file.attach(io: file_fixture(file_2).open, filename: file_2)
    assert report_1.save
    assert_equal 105.0, report_1.income
  end
end
