class AddEmailAndPhoneNumberToCities < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :email, :string
    add_column :cities, :phone_number, :string
  end
end
