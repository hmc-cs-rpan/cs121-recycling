require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  require_properties_for Category, :name
  define_property :image_url, as: :url

  test "can create category with name and valid image URL" do
    with_properties valid: :image_url, name: 'new category' do |props|
      assert_valid Category, props
    end
  end

  test "can create category without image" do
    assert_valid Category, name: 'new category'
  end

  test "cannot create category with invalid image URL" do
    with_properties invalid: :image_url, name: 'new category' do |props|
      assert_invalid Category, { image_url: :invalid }, props
    end
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
