require "test_helper"

class BusinessEntityTest < ActiveSupport::TestCase
  test "should not save business entity without name" do
    business_entity = BusinessEntity.new
    assert_not business_entity.save, "Saved the business entity without a name"
  end

  test "should not save business entity without share supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd")
    assert_not business_entity.save, "Saved the business entity without a share supply"
  end

  test "should save business entity with share supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100)
    assert business_entity.save, "Did not save the business entity with a share supply"
  end

  test "should save business entity with sold supply" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 0)
    assert business_entity.save, "Did not save the business entity with a sold supply"
  end

  test "should not save business entity with duplicate name" do
    business_entity = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 0)
    business_entity.save!
    business_entity_duplicate = BusinessEntity.new(name: "Acme ltd", share_supply: 100, sold_supply: 0)
    assert_not business_entity_duplicate.save, "Saved the business entity with a duplicate name"
  end
end
