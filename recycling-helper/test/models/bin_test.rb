require 'test_helper'

class BinTest < ActiveSupport::TestCase
  properties_for Bin, required: [:name, :city, :color]

  test "can get city" do
    assert_equal cities(:claremont), bins(:claremont_recycling).city
  end

  test "can get items" do
    assert_equal Item.find(items(:newspaper).id, items(:plastic_bottle).id),
                 bins(:claremont_recycling).items
  end

  test "items are sorted by name" do
    bin = Bin.create! name: 'test', city: cities(:claremont), color: '#000000'
    bin.items.create! [
      { name: 'c', category: categories(:paper) },
      { name: 'z', category: categories(:paper) },
      { name: 'a', category: categories(:paper) }
    ]

    assert_equal bin.items.order(:name), bin.items, 'items were not sorted'
  end

  test "cannot create duplicate bins for the same city" do
    bin = bins(:claremont_recycling)

    assert_raise ActiveRecord::RecordNotUnique do
      Bin.create(name: bin.name, city: bin.city, color: '#000000')
    end
  end

  test "can add existing item" do
    bin = bins(:claremont_recycling)
    item = Item.create(name: 'new item', category: categories(:paper))
    item_in_bin = bin.add_item! item.name, item.category

    # Should just refer to the same item
    assert_includes bin.items, item, 'new item is not in bin'
    assert_equal item, bin.items.find(item.id), 'new item in bin does not refer to existing item'
    assert_equal item, item_in_bin, 'new item in bin was not returned from add_item'
  end

  test "can create new item" do
    bin = bins(:claremont_recycling)
    items = Item.select('id')
    item = bin.add_item! 'new item', categories(:paper)

    assert_not_includes items, item.id, 'a new item was not created'
    assert_equal item, Item.find(item.id), 'the new item was not in the database'
    assert_equal item, bin.items.find(item.id), 'the new item was not in the bin\'s items'

    assert_equal 'new item', item.name
    assert_equal categories(:paper), item.category
  end

  test "cannot add existing item with the wrong category" do
    bin = bins(:claremont_recycling)
    item = Item.create(name: 'new item', category: categories(:paper))
    wrong_category = categories(:plastic)
    assert_not_equal item.category, wrong_category, 'the test is broken'

    # Get the state before the test, so we can make sure it doesn't change when the operation fails
    before_items = Item.all
    before_items_in_bin = bin.items.all

    # Misbehave
    assert_raise Errors::InvalidCategoryForItem do
      bin.add_item! item.name, wrong_category
    end

    # the database should be unchanged
    assert_equal before_items, Item.all, 'items table was changed by the failed operation'
    assert_equal before_items_in_bin, bin.items.all, 'bin\'s items were changed by the failed operation'
  end
end
