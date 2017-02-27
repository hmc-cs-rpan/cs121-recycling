class AddUniquenessConstraintToItems < ActiveRecord::Migration[5.0]
  def change
    add_index :items, :name, unique: true
  end
end
