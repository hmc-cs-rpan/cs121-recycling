class AddUniqueNameAndCityToBins < ActiveRecord::Migration[5.0]
  def change
    add_index :bins, [:name, :city_id], unique: true
  end
end
