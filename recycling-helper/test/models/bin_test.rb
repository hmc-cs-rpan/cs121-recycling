require 'test_helper'

class BinTest < ActiveSupport::TestCase
  test "can get city" do
    assert_equal cities(:claremont), bins(:claremont_recycling).city
  end

  test "can get items" do
    assert_equal Item.find(items(:newspaper).id, items(:plastic_bottle).id),
                 bins(:claremont_recycling).items
  end

  test "can add existing item" do
    bin = bins(:claremont_recycling)
    item = Item.create(name: 'new item', category: categories(:paper))
    item_in_bin = bin.add_item! 'new item', categories(:paper)

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
end
