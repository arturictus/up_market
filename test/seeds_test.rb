require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  test "should seed the database" do
    Rails.application.load_seed
    assert_equal BusinessOwner.count, 1
    assert_equal BusinessEntity.count, 3
    assert_equal Buyer.count, 1
  end
end
