require 'test_helper'

class ShoppingcartItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shoppingcart_item = shoppingcart_items(:one)
  end

  test "should get index" do
    get shoppingcart_items_url, as: :json
    assert_response :success
  end

  test "should create shoppingcart_item" do
    assert_difference('ShoppingcartItem.count') do
      post shoppingcart_items_url, params: { shoppingcart_item: { menus_id: @shoppingcart_item.menus_id, quantity: @shoppingcart_item.quantity, shoppingcarts_id: @shoppingcart_item.shoppingcarts_id } }, as: :json
    end

    assert_response 201
  end

  test "should show shoppingcart_item" do
    get shoppingcart_item_url(@shoppingcart_item), as: :json
    assert_response :success
  end

  test "should update shoppingcart_item" do
    patch shoppingcart_item_url(@shoppingcart_item), params: { shoppingcart_item: { menus_id: @shoppingcart_item.menus_id, quantity: @shoppingcart_item.quantity, shoppingcarts_id: @shoppingcart_item.shoppingcarts_id } }, as: :json
    assert_response 200
  end

  test "should destroy shoppingcart_item" do
    assert_difference('ShoppingcartItem.count', -1) do
      delete shoppingcart_item_url(@shoppingcart_item), as: :json
    end

    assert_response 204
  end
end
