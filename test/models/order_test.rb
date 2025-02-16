require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "should not save order without business_entity" do
    order = Order.new
    assert_not order.save, "Saved the order without a business_entity"
  end
  # test "should not save order without buyer" do
  #   order = Order.new
  #   assert_not order.save, "Saved the order without a buyer"
  # end

  # test "should not save order without shares" do
  #   order = Order.new
  #   assert_not order.save, "Saved the order without shares"
  # end

  # test "should not save order without price_per_share" do
  #   order = Order.new
  #   assert_not order.save, "Saved the order without price_per_share"
  # end

  test ".create_order! should save order with business_entity" do
    entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0)
    buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    order = Order.create_order!(buyer: buyer, business_entity: entity, shares: 10, price_per_share: 10)
    assert order.persisted?, "Did not save the order with a business_entity"
    assert_not order.executed, "Saved the order executed"
  end

  test ".create_and_execute! should save order with business_entity" do
    entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0)
    buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    order = Order.create_and_execute!(buyer: buyer, business_entity: entity, shares: 10, price_per_share: 10)
    assert order.persisted?, "Did not save the order with a business_entity"
    assert order.executed, "Did not save the order executed"
  end
end
