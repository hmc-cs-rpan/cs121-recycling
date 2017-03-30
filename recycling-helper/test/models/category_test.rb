require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  define_property :image_url, as: :url

  properties_for Category,
    required: [:name],
    optional: [:image_url]

  test "cannot create two categories with the same name" do
    existing = categories(:plastic)
    new_category = Category.new(name: existing.name, image_url: valid_url)
    assert new_category.valid?, 'test category is invalid: #{category.errors.full_messages}'

    assert_raise ActiveRecord::RecordNotUnique do
      new_category.save
    end
  end

  test "can get items" do
    categories.each do |c|
      assert_equal items.where(category: c), c.items
    end
  end

  test "items are sorted by name" do
    category = Category.create! name: 'test'
    category.items.create! [
      { name: 'c' },
      { name: 'z' },
      { name: 'a' }
    ]

    assert_equal category.items.order(:name), category.items, 'items were not sorted'
  end
end
