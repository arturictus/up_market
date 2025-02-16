require "test_helper"

class BusinessEntityTest < ActiveSupport::TestCase
  def setup
    @owner = BusinessOwner.create!(name: "John Doe")
  end
  test "should not save business entity without name" do
    business_entity = BusinessEntity.new
    assert_not business_entity.save, "Saved the business entity without a name"
  end

  test "should not save business entity without share supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", business_owner: @owner)
    assert_not business_entity.save, "Saved the business entity without a share supply"
  end

  test "should save business entity with share supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, business_owner: @owner)
    assert business_entity.save, "Did not save the business entity with a share supply"
  end

  test "should save business entity with sold supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    assert business_entity.save, "Did not save the business entity with a sold supply"
  end

  test "should not save business entity with duplicate name" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    business_entity.save!
    business_entity_duplicate = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
    assert_not business_entity_duplicate.save, "Saved the business entity with a duplicate name"
  end

  test "should not save business entity with negative share supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: -100, sold_supply: 0, business_owner: @owner)
    assert_not business_entity.save, "Saved the business entity with a negative share supply"
  end

  test "should not save business entity with negative sold supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: -100, business_owner: @owner)
    assert_not business_entity.save, "Saved the business entity with a negative sold supply"
  end

  test "should not save business entity with sold supply greater than share supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 101, business_owner: @owner)
    assert_not business_entity.save, "Saved the business entity with a sold supply greater than share supply"
  end
end
