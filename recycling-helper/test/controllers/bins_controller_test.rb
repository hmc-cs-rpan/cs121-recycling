require 'test_helper'

class BinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bin = bins(:claremont_recycling)
  end


  test "should create bin" do
    assert_difference('Bin.count') do
      post bins_url, params: {
        bin: {
          name: 'new bin',
          city_id: cities(:claremont).id,
          red: 0, green: 0, blue: 0, alpha: 1
        }
      }
    end

    assert_redirected_to bin_url(Bin.last)
  end

  test "should update bin" do
    patch bin_url(@bin), params: { bin: { name: 'updated name' } }
    assert_redirected_to bin_url(@bin)
  end

  test "should destroy bin" do
    assert_difference('Bin.count', -1) do
      delete bin_url(@bin)
    end

    assert_redirected_to bins_url
  end

end
