require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'report has a file' do
    assert_have_one_attached(Report, :file)
  end

  test 'report presence validations' do
    object = Report.new
    assert_not object.valid?
    assert_includes object.errors.messages.keys, :name
    assert_includes object.errors.messages.keys, :file
  end
end
