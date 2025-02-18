require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = BusinessOwner.create!(name: "John Doe")
    @entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    @buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    @order = Order.create_order!(buyer: @buyer, business_entity: @entity, shares: 10, price_per_share: 10)
  end

  test "#index should get orders index" do
    get orders_url
    response = JSON.parse(@response.body)
    assert_equal @order.business_entity.id, response["data"][0]["business_entity_id"]
    assert_response :success
  end
end
