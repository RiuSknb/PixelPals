require "test_helper"

class Admin::GroupsMembersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_groups_members_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_groups_members_show_url
    assert_response :success
  end

  test "should get create" do
    get admin_groups_members_create_url
    assert_response :success
  end

  test "should get update" do
    get admin_groups_members_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_groups_members_destroy_url
    assert_response :success
  end
end
