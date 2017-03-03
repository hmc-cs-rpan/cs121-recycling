class AddUniquenessConstraintToCities < ActiveRecord::Migration[5.0]
  def change
    add_index :cities, [:name, :state, :zip], unique: true
  end
end
