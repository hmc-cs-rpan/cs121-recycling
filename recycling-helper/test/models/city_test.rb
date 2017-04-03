require 'test_helper'

class CityTest < ActiveSupport::TestCase
  require_properties_for City, :name, :state, :location_id
  define_property :website_url, as: :url

  test "can create city with name, state, location, and valid url" do
    with_properties valid: [:state, :website_url, :location_id], name: 'Claremont' do |props|
      assert_valid City, props
    end
  end

  test "cannot create city with invalid state" do
    with_properties invalid: :state, valid: :location_id, name: 'Claremont' do |props|
      assert_invalid City, { state: :invalid }, props
    end
  end

  test "cannot create city with invalid url" do
    with_properties invalid: :website_url, valid: [:state, :location_id], name: 'Claremont' do |props|
      assert_invalid City, { website_url: :invalid }, props
    end
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
