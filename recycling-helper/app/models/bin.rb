class Bin < ApplicationRecord
  validates :name, :city, presence: true

  belongs_to :city
  has_and_belongs_to_many :items

  # Add an item to this bin, reusing an existing item if possible. Returns the added item. If the
  # item exists but does not match category, then an exception will be raised and the database will
  # not be touched.
  def add_item!(name, category)
    begin
      result = Item.create(name: name, category: category)
      items << result
    rescue ActiveRecord::RecordNotUnique
      # This item already exists in the database
      existing = Item.find_by name: name

      # Verify that this is really the item we think it is: it should have the correct category
      if existing.category == category
        result = existing
        items << result
      else
        # Something has gone wrong
        raise Errors::InvalidCategoryForItem,
          "category for \"#{name}\" should be \"#{existing.category.name}\""
      end
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
