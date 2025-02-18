require "test_helper"

class BuyerTest < ActiveSupport::TestCase
  test "should not save buyer without name" do
    buyer = Buyer.new
    assert_not buyer.save, "Saved the buyer without a name"
  end
end
