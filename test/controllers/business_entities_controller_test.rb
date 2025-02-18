require "test_helper"

class BusinessEntitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @owner = BusinessOwner.create!(name: "John Doe")
    @entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    @buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
  end

  test "#index should get business_entities index" do
    get business_entities_url
    response = JSON.parse(@response.body)
    assert_equal @entity.name, response["data"][0]["name"]
    assert_response :success
  end

  test "#show should get show" do
    get business_entity_url(@entity)
    assert_response :success
  end

  test "#show should be not found" do
    get business_entity_url(6)
    assert_response :not_found
  end
end
