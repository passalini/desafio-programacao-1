require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  test 'validations' do
    object = Purchase.new
    assert_not object.valid?
    assert_includes object.errors.messages.keys, :count
    assert_includes object.errors.messages.keys, :user
    assert_includes object.errors.messages.keys, :purchaser
    assert_includes object.errors.messages.keys, :item
    assert_includes object.errors.messages.keys, :report
  end
end
