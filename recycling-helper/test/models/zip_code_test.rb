require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase
  define_property :name, as: :zip
  refer_property :city, to: City

  properties_for ZipCode, required: [:name, :city]

  test "cannot create duplicate zip code" do
    zip = ZipCode.new name: zip_codes(:claremont_zip).name, city: cities(:claremont)
    assert_no_difference 'ZipCode.count' do
      assert_raise ActiveRecord::RecordNotUnique do
        zip.save
      end
    end
  end
end
