require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  require_properties_for Item, :name, :category

  test "can get category" do
    assert_equal categories(:plastic), items(:plastic_bottle).category
  end

  test "cannot create duplicate items" do
    item = items(:plastic_bottle)

    assert_raise ActiveRecord::RecordNotUnique do
      # Category can be whatever, this should still fail
      Item.create(name: item.name, category: categories(:paper))
    end
  end
end
