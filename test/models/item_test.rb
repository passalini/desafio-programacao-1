require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'validations' do
    object = Item.new
    assert_not object.valid?
    assert_includes object.errors.messages.keys, :name
    assert_includes object.errors.messages.keys, :price
    assert_includes object.errors.messages.keys, :user
    assert_includes object.errors.messages.keys, :merchant
  end
end
