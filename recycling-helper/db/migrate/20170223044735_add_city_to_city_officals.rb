class AddCityToCityOfficals < ActiveRecord::Migration[5.0]
  def change
    add_reference :city_officials, :city, foreign_key: true
  end
end
