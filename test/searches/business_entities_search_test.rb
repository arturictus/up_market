require "test_helper"

class BusinessEntitiesSearchTest < ActiveSupport::TestCase
  setup do
    @owner = BusinessOwner.create!(name: "John Doe")
    @entity = BusinessEntity.create!(name: "Acme ltd", share_supply: 100, sold_supply: 0, business_owner: @owner)
  end


  test "should find business by owner" do
    result = BusinessEntitiesSearch.new(owner_id: @owner.id).filter

    assert_equal 1, result.count
  end

  test "should find business by remaining_supply" do
    result = BusinessEntitiesSearch.new(remaining_supply: true).filter

    assert_equal 1, result.count

    result = BusinessEntitiesSearch.new(remaining_supply: "true").filter

    assert_equal 1, result.count

    result = BusinessEntitiesSearch.new(remaining_supply: false).filter
    assert_equal 0, result.count
  end

  test "errors" do
    search = BusinessEntitiesSearch.new(owner_id: "hello")
    search.filter

    assert_not search.valid?
    assert_not search.errors.empty?

    search = BusinessEntitiesSearch.new(remaining_supply: "invalid")
    search.filter

    assert_not search.valid?
    assert_not search.errors.empty?
  end
end
