class CreateZipCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :zip_codes do |t|
      t.string :name
      t.index :name, unique: true

      t.timestamps
    end
  end
end
