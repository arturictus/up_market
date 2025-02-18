require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = BusinessOwner.create!(name: "John Doe")
    @entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    @buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    @order = Order.create_order!(buyer: @buyer, business_entity: @entity, shares: 10, price_per_share: 10)
    @credentials = ActionController::HttpAuthentication::Basic.encode_credentials("test", "password")
  end

  test "#index should get orders index" do
    get orders_url, params: { business_entity_id: @order.business_entity.id },
                    headers: { "Authorization" => @credentials }
    response = JSON.parse(@response.body)
    assert_equal @order.business_entity.id, response["data"][0]["business_entity_id"]
    assert_response :success
  end

  test "#create should create order" do
    assert_difference("Order.count") do
      post orders_url, params: { order: { buyer_id: @buyer.id, business_entity_id: @entity.id, shares: 10, price_per_share: 10 } },
                       headers: { "Authorization" => @credentials }
    end
    assert_response :created
  end

  test "#create should not create order when errors" do
    assert_no_difference("Order.count") do
      post orders_url, params: { order: { buyer_id: @buyer.id, business_entity_id: @entity.id, shares: 10, price_per_share: -10 } },
                       headers: { "Authorization" => @credentials }
    end
    response = JSON.parse(@response.body)
    response.dig("errors", "price_per_share").each do |error|
      assert_equal "must be greater than 0", error
    end
    assert_response :unprocessable_entity
  end

  test "#execute should execute order" do
    patch execute_order_url(@order), headers: { "Authorization" => @credentials }
    assert_response :success
    assert Order.find(@order.id).executed
  end
end
