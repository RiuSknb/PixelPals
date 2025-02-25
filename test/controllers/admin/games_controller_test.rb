require "test_helper"

class Admin::GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_games_new_url
    assert_response :success
  end

  test "should get index" do
    get admin_games_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_games_show_url
    assert_response :success
  end

  test "should get create" do
    get admin_games_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_games_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_games_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_games_destroy_url
    assert_response :success
  end
end
