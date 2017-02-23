require 'test_helper'

class CityOfficialTest < ActiveSupport::TestCase
  test "can get city" do
    assert_equal cities(:claremont), city_officials(:claremont1).city
  end
end
