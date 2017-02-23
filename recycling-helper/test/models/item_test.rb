require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "can get category" do
    assert_equal categories(:plastic), items(:plastic_bottle).category
  end
end
