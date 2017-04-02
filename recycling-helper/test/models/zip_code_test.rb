require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase
  require_properties_for ZipCode, :name, :city
  define_property :name, as: :zip
  refer_property :city, to: City

  test "cannot create invalid zip code" do
    with_properties invalid: :name do |props|
      assert_invalid ZipCode, { name: :invalid }, props
    end
  end

  test "cannot create duplicate zip code" do
    zip = ZipCode.new name: zip_codes(:claremont_zip).name, city: cities(:claremont)
    assert_no_difference 'ZipCode.count' do
      assert_raise ActiveRecord::RecordNotUnique do
        zip.save
      end
    end
  end
end
