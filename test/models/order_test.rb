require "test_helper"

class OrderTest < ActiveSupport::TestCase
  def setup
    @owner = BusinessOwner.create!(name: "John Doe")
    @entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    @buyer = Buyer.create!(name: "John Doe")
  end
  test "should not save order without business_entity" do
    order = Order.new
    assert_not order.save, "Saved the order without a business_entity"
  end

  test ".create_order! should save order with business_entity" do
    order = Order.create_order!(buyer: @buyer, business_entity: @entity, shares: 10, price_per_share: 10)
    assert order.persisted?, "Did not save the order with a business_entity"
    assert_not order.executed, "Saved the order executed"
  end

  test ".create_and_execute! should save order with business_entity" do
    order = Order.create_and_execute!(buyer: @buyer, business_entity: @entity, shares: 10, price_per_share: 10)
    assert order.persisted?, "Did not save the order with a business_entity"
    assert order.executed, "Did not save the order executed"
  end
end
