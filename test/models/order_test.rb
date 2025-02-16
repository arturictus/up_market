require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "should not save order without business_entity" do
    order = Order.new
    assert_not order.save, "Saved the order without a business_entity"
  end
  test "should not save order without buyer" do
    order = Order.new
    assert_not order.save, "Saved the order without a buyer"
  end

  test "should not save order without shares" do
    order = Order.new
    assert_not order.save, "Saved the order without shares"
  end

  test "should not save order without price_per_share" do
    order = Order.new
    assert_not order.save, "Saved the order without price_per_share"
  end
end
