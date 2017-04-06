require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  properties_for Item, required: [:name, :category], optional: [:image]

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
