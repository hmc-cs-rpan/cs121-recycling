class AddFirstNameMiddleNameLastNameToAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :admins, :first_name, :string
    add_column :admins, :middle_name, :string
    add_column :admins, :last_name, :string
  end
end
