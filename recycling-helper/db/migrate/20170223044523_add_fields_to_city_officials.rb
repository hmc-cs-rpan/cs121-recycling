class AddFieldsToCityOfficials < ActiveRecord::Migration[5.0]
  def change
    add_column :city_officials, :first_name, :string
    add_column :city_officials, :middle_name, :string
    add_column :city_officials, :last_name, :string
  end
end
