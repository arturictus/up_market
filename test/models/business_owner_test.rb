require "test_helper"

class BusinessOwnerTest < ActiveSupport::TestCase
  test "should not save business owner without name" do
    owner = BusinessOwner.new
    assert_not owner.save, "Saved the business owner without a name"
  end

  test "should have many business entities" do
    owner = BusinessOwner.create!(name: "John Doe")
    entity1 = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: owner)
    entity2 = BusinessEntity.create!(name: "Rockets inc", share_supply: 100, sold_supply: 0, business_owner: owner)
    assert_equal [ entity1, entity2 ], owner.business_entities
  end

  test "should have many orders through business entities" do
    owner = BusinessOwner.create!(name: "John Doe")
    entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: owner)
    buyer = Buyer.create!(name: "John Doe")
    order1 = Order.create_order!(buyer: buyer, business_entity: entity, shares: 10, price_per_share: 10)
    order2 = Order.create_order!(buyer: buyer, business_entity: entity, shares: 10, price_per_share: 10)
    assert_equal [ order1, order2 ], owner.orders
  end
end
