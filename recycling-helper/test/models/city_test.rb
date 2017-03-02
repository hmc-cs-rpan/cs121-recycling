require 'test_helper'

class CityTest < ActiveSupport::TestCase
  require_properties_for City, :name, :state, :zip

  test "can create city with name, state, zip, and valid url" do
    assert_valid City, name: 'Claremont', state: valid_state, zip: valid_zip, website_url: valid_url
  end

  test "cannot create city with invalid state" do
    assert_invalid City, { state: :invalid },
      name: 'Claremont', state: invalid_state, zip: valid_zip
  end

  test "cannot create city with invalid url" do
    assert_invalid City, { website_url: :invalid },
      name: 'Claremont', state: valid_state, zip: valid_zip, website_url: invalid_url
  end

  test "cannot create city with invalid zip" do
    assert_invalid City, { zip: :invalid },
      name: 'Claremont', state: valid_state, zip: invalid_zip
  end

  test "can get all city officials" do
    assert_equal CityOfficial.where(city: cities(:claremont)), cities(:claremont).officials
  end

  test "can get all bins" do
    assert_equal Bin.where(city: cities(:pasadena)), cities(:pasadena).bins
  end

  test "can get all categories" do
    assert_equal Category.where('name="plastic" OR name="paper"'), cities(:pasadena).categories
  end

  test "can get all items" do
    assert_equal items(:newspaper, :plastic_bottle), cities(:pasadena).items
  end

  test "can get items by bin" do
    bin = bins(:pasadena_compost)
    assert_equal bin.items, cities(:pasadena).bins.where(name: bin.name)[0].items
  end

  test "can get items by category" do
    category = categories(:paper)
    assert_equal category.items, cities(:pasadena).categories.where(name: category.name)[0].items
  end
end
