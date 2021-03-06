class Bin < ApplicationRecord
  validates :name, :city, :red, :green, :blue, :alpha, presence: true
  validates :red, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 255 },
    if: 'red.present?'
  validates :green, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 255 },
    if: 'green.present?'
  validates :blue, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 255 },
    if: 'blue.present?'
  validates :alpha, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 },
    if: 'alpha.present?'

  belongs_to :city
  has_and_belongs_to_many :items, ->{ order :name }
  has_many :categories, -> { distinct }, through: :items

  # Add an item to this bin, reusing an existing item if possible. Returns the added item. If the
  # item exists but does not match category, then an exception will be raised and the database will
  # not be touched.
  def add_item!(name, category, image)
    begin
      result = Item.create(name: name, category: category, image: image)
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
      add_item! item[:name], item[:category], item[:image]
    end
  end

  def color
    { red: red, green: green, blue: blue, alpha: alpha }
  end

  def css_color
    "rgba(#{red}, #{green}, #{blue}, #{alpha})"
  end

end
