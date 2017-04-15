class StoreBinColorAsRgba < ActiveRecord::Migration[5.0]
  def change
    remove_column :bins, :color
    add_column :bins, :red, :integer
    add_column :bins, :green, :integer
    add_column :bins, :blue, :integer
    add_column :bins, :alpha, :decimal
  end
end
