require 'test_helper'

class Admin::ShopsControllerTest < ActionController::TestCase
  setup do
    @admin_shop = admin_shops(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_shops)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create admin_shop" do
    assert_difference('Admin::Shop.count') do
      post :create, admin_shop: {  }
    end

    assert_redirected_to admin_shop_path(assigns(:admin_shop))
  end

  test "should show admin_shop" do
    get :show, id: @admin_shop
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @admin_shop
    assert_response :success
  end

  test "should update admin_shop" do
    patch :update, id: @admin_shop, admin_shop: {  }
    assert_redirected_to admin_shop_path(assigns(:admin_shop))
  end

  test "should destroy admin_shop" do
    assert_difference('Admin::Shop.count', -1) do
      delete :destroy, id: @admin_shop
    end

    assert_redirected_to admin_shops_path
  end
end
