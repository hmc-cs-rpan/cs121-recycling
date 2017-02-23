class CreateBinsAndItems < ActiveRecord::Migration[5.0]
  def change
    create_table :bins_items, id: false do |t|
      t.belongs_to :bin, index: true
      t.belongs_to :item, index: true
    end
  end
end
