require 'test_helper'

class CityOfficialTest < ActiveSupport::TestCase
  test "can create city official with first name, last name, email, password, and city" do
    official = CityOfficial.new(first_name: 'John', last_name: 'Doe', email: 'jd@example.com',
                                password: 'password', city: cities(:claremont))
    assert official.save, "failed to create city official: #{official.errors.full_messages}"
  end

  test "cannot create city official without city" do
    official = CityOfficial.new(
      first_name: 'John', last_name: 'Doe', email: 'jd@example.com', password: 'password')
    refute official.save, "created city official without city"
  end

  test "cannot create city official without first name" do
    official = CityOfficial.new(
      last_name: 'Doe', email: 'jd@example.com', password: 'password', city: cities(:claremont))
    refute official.save, "created city official without first name"
  end

  test "cannot create city official without last name" do
    official = CityOfficial.new(
      first_name: 'John', email: 'jd@example.com', password: 'password', city: cities(:claremont))
    refute official.save, "created city official without last name"
  end

  test "can get city" do
    assert_equal cities(:claremont), city_officials(:claremont1).city
  end
end
