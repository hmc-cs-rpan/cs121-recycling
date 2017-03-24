class AddLocationIdToCity < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :location_id, :string
    remove_column :cities, :zip
    add_index :cities, :location_id, unique: true
  end
end
