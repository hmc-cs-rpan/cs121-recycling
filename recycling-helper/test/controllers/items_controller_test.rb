require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:newspaper)
  end

  test "should create item" do
    assert_difference('Item.count') do
      post items_url, params: { item: { name: 'new item', category_id: categories(:plastic).id } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should update item name" do
    new_name = 'new name'
    refute_equal @item.name, new_name, "the test itself appears to be broken"

    patch item_url(@item), params: { item: { name: new_name } }
    assert_redirected_to item_url(@item)
    assert_equal new_name, Item.find(@item.id).name
  end

  test "should update item category" do
    new_category = categories(:plastic)
    refute_equal @item.category, new_category, "the test itself appears to be broken"

    patch item_url(@item), params: { item: { category_id: new_category.id } }
    assert_redirected_to item_url(@item)
    assert_equal new_category, Item.find(@item.id).category
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
