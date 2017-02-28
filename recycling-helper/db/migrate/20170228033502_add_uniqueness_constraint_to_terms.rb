class AddUniquenessConstraintToTerms < ActiveRecord::Migration[5.0]
  def change
    add_index :terms, :name, unique: true
  end
end
