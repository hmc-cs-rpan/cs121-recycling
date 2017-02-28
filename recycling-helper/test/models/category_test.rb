require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  require_properties_for Category, :name

  test "can create category with name and valid image URL" do
    category = Category.new(name: 'new category', image_url: valid_url)
    assert category.save, "failed to save category: #{category.errors.full_messages}"
  end

  test "can create category without image" do
    category = Category.new(name: 'new category')
    assert category.save, 'failed to save category: #{category.errors.full_messages}'
  end

  test "cannot create category with invalid image URL" do
    category = Category.new(name: 'new category', image_url: invalid_url)
    refute category.save, 'saved category with invalid image URL'
  end

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
end
