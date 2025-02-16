require "test_helper"

class BasicAuthTest < ActiveSupport::TestCase
  test "should not save basic auth without username" do
    basic_auth = BasicAuth.new
    assert_not basic_auth.save, "Saved the basic auth without a username"
  end

  test "should not save basic auth without password digest" do
    basic_auth = BasicAuth.new(username: "test")
    assert_not basic_auth.save, "Saved the basic auth without a password digest"
  end

  test "#find_by_username_and_password should find by username and password" do
    basic_auth = BasicAuth.create!(username: "test", password: "password")
    assert_equal basic_auth, BasicAuth.find_by_username_and_password(username: "test", password: "password")
    assert_not_equal basic_auth.password_digest, "password"
  end

  test "#find_by_username_and_password should not find by username and password" do
    BasicAuth.create!(username: "test", password: "password")
    assert_nil BasicAuth.find_by_username_and_password(username: "test", password: "wrong")
    assert_nil BasicAuth.find_by_username_and_password(username: "nop", password: "password")
  end
end
