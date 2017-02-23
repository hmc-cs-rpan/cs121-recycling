class Bin < ApplicationRecord
  belongs_to :city
  has_and_belongs_to_many :items

  # Add an item to this bin, reusing an existing item if possible. Returns the added item.
  def add_item!(name, category)
    existing = Item.where({name: name, category: category})
    if existing.empty?
      result = items.create(name: name, category: category)
    else
      items << existing[0]
      result = existing[0]
    end

    result
  end

  # Add a series of items to this bin, reusing existing items where possible. Items must respond to
  # each, and each item should be a hash containing keys :name and :category.
  def add_items!(items)
    items.map do |item|
      add_item! item[:name], item[:category]
    end
  end

end
