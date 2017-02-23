require 'test_helper'

class BinTest < ActiveSupport::TestCase
  test "can get city" do
    assert_equal cities(:claremont), bins(:claremont_recycling).city
  end

  test "can get items" do
    assert_equal Item.find(items(:newspaper).id, items(:plastic_bottle).id),
                 bins(:claremont_recycling).items
  end
end
