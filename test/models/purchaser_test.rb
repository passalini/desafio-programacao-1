require 'test_helper'

class PurchaserTest < ActiveSupport::TestCase
  test 'validations' do
    object = Purchaser.new
    assert_not object.valid?
    assert_includes object.errors.messages.keys, :name
    assert_includes object.errors.messages.keys, :user
  end
end
