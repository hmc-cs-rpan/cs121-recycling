class AddCityToZipCode < ActiveRecord::Migration[5.0]
  def change
    add_reference :zip_codes, :city, foreign_key: true
  end
end
