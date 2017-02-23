require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "can get items" do
    categories.each do |c|
      assert_equal items.where(category: c), c.items
    end
  end
end
