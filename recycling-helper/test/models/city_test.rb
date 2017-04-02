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

  test "can create new bin" do
    city = cities(:claremont)
    bins = Bin.select('id')
    bin = city.add_bin! 'new bin'

    assert_not_includes bins, bin.id, 'a new bin was not created'
    assert_equal bin, Bin.find(bin.id), 'the new bin was not in the database'
    assert_nothing_raised do
      city.bins.find(bin.id) # Will raise ActiveRecord::Record not found if bin was not added
    end
    assert_equal 'new bin', bin.name
  end

  test "can add existing bin to no affect" do
    city = cities(:claremont)
    bin_to_add = city.bins.first

    bin = nil
    assert_no_difference 'Bin.count', 'the bins table was changed' do
      bin = city.add_bin! bin_to_add.name
    end

    assert_equal bin_to_add, bin, 'the returned bin was different from the existing bin'
    assert_equal bin_to_add, city.bins.find(bin.id), 'the city\'s bin was changed'
  end

end
