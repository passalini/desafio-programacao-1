require 'test_helper'

class MerchantTest < ActiveSupport::TestCase
  test 'validations' do
    object = Merchant.new
    assert_not object.valid?
    assert_includes object.errors.messages.keys, :name
    assert_includes object.errors.messages.keys, :user
  end
end
