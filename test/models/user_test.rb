require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#calculate_income!' do
    user = users(:one)
    user.income = 0

    assert_difference('user.income', 200) do
      user.calculate_income!
    end
  end
end
