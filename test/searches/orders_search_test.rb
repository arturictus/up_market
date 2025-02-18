require "test_helper"

class OrdersSearchTest < ActiveSupport::TestCase
  setup do
    @owner = BusinessOwner.create!(name: "John Doe")
    @entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    @buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    @order = Order.create_order!(buyer: @buyer, business_entity: @entity, shares: 10, price_per_share: 10)
    random_order
  end


  test "should find orders by business_entity" do
    result = OrdersSearch.new(business_entity_id: @entity.id).filter
    assert_equal 1, result.count
  end

  test "should find orders by buyer" do
    result = OrdersSearch.new(buyer_id: @buyer.id).filter
    assert_equal 1, result.count
  end

  test "errors" do
    result = OrdersSearch.new(business_entity_id: "hello")

    result.filter

    assert_not result.valid?
    assert_not result.errors.empty?
  end

  def random_order
    owner = BusinessOwner.create!(name: "Gozila")
    entity = BusinessEntity.create!(name: "Apple ltd", share_supply: 100, sold_supply: 0, business_owner: owner)
    buyer = Buyer.create_with_basic_auth!(name: "John Wick", username: "other_test", password: "password")
    Order.create_order!(buyer: buyer, business_entity: entity, shares: 10, price_per_share: 10)
  end
end
