require 'test_helper'

class CityTest < ActiveSupport::TestCase
  define_property :website_url, as: :url

  properties_for City,
    required: [:name, :state, :location_id, :latitude, :longitude],
    optional: [:website_url]

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

  test "can get nearby cities given a location" do
    claremont = cities(:claremont)
    pasadena = cities(:pasadena)
    schmorbodia = cities(:schmorbodia)

    assert_equal [claremont, pasadena], City.near([claremont.latitude, claremont.longitude], 100),
      'could not find cities nearby to Claremont'
    assert_equal [schmorbodia], City.near([schmorbodia.latitude, schmorbodia.longitude]),
      'could not find cities nearby to Schmorbodia'
  end

end
