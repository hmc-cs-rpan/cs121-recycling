class AddColorToBins < ActiveRecord::Migration[5.0]
  def change
    add_column :bins, :color, :string
  end
end
