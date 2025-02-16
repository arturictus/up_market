require "test_helper"

class BuyerTest < ActiveSupport::TestCase
  test "should not save buyer without name" do
    buyer = Buyer.new
    assert_not buyer.save, "Saved the buyer without a name"
  end

  test "should not save buyer without basic_auth" do
    buyer = Buyer.new(name: "John Doe")
    assert_not buyer.save, "Saved the buyer without an email"
  end

  test "#create_with_basic_auth! should save buyer with basic_auth" do
    buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    assert buyer.persisted?, "Did not save the buyer with a basic_auth"
  end

  test "#find_by_username_and_password should find buyer by username and password" do
    buyer = Buyer.create_with_basic_auth!(name: "John Doe", username: "test", password: "password")
    assert_equal buyer, Buyer.find_by_username_and_password(username: "test", password: "password")
    assert_nil Buyer.find_by_username_and_password(username: "test", password: "wrong")
  end
end
